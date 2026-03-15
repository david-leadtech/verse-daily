import { Router, type IRouter } from "express";
import { db } from "@workspace/db";
import { versesTable, dailyVersesTable, booksTable } from "@workspace/db/schema";
import { eq, and, sql } from "drizzle-orm";

const router: IRouter = Router();

function clampInt(value: unknown, defaultVal: number, min: number, max: number): number {
  const n = Number(value);
  if (isNaN(n) || n < min) return defaultVal;
  return Math.min(Math.floor(n), max);
}

const BOOK_API_NAMES: Record<string, string> = {
  "1 Samuel": "1Samuel",
  "2 Samuel": "2Samuel",
  "1 Kings": "1Kings",
  "2 Kings": "2Kings",
  "1 Chronicles": "1Chronicles",
  "2 Chronicles": "2Chronicles",
  "Song of Solomon": "SongOfSolomon",
  "1 Corinthians": "1Corinthians",
  "2 Corinthians": "2Corinthians",
  "1 Thessalonians": "1Thessalonians",
  "2 Thessalonians": "2Thessalonians",
  "1 Timothy": "1Timothy",
  "2 Timothy": "2Timothy",
  "1 Peter": "1Peter",
  "2 Peter": "2Peter",
  "1 John": "1John",
  "2 John": "2John",
  "3 John": "3John",
};

const fullyLoadedChapters = new Set<string>();

async function fetchAndCacheVerses(book: string, chapter: number): Promise<typeof versesTable.$inferSelect[]> {
  const key = `${book}:${chapter}`;
  if (fullyLoadedChapters.has(key)) return [];
  fullyLoadedChapters.add(key);
  try {
    const apiBookName = BOOK_API_NAMES[book] || book;
    const url = `https://bible-api.com/${encodeURIComponent(apiBookName)}+${chapter}?translation=kjv`;
    const response = await fetch(url, { signal: AbortSignal.timeout(8000) });

    if (!response.ok) return [];

    const data = await response.json() as {
      verses?: Array<{ book_name: string; chapter: number; verse: number; text: string }>;
    };

    if (!data.verses || data.verses.length === 0) return [];

    const versesToInsert = data.verses.map((v) => ({
      book,
      chapter: v.chapter,
      verseNumber: v.verse,
      text: v.text.replace(/\n/g, " ").trim(),
      version: "KJV" as const,
    }));

    await db.delete(versesTable).where(
      and(eq(versesTable.book, book), eq(versesTable.chapter, chapter))
    );
    const inserted = await db.insert(versesTable).values(versesToInsert).returning();
    return inserted;
  } catch (error) {
    console.error(`Error fetching from Bible API for ${book} ${chapter}:`, error);
    return [];
  }
}

router.get("/verses/daily", async (_req, res) => {
  try {
    const today = new Date().toISOString().split("T")[0];
    let daily = await db
      .select()
      .from(dailyVersesTable)
      .where(eq(dailyVersesTable.date, today!))
      .limit(1);

    if (daily.length === 0) {
      const randomVerse = await db
        .select()
        .from(versesTable)
        .orderBy(sql`RANDOM()`)
        .limit(1);

      if (randomVerse.length === 0) {
        res.status(404).json({ error: "No verses found" });
        return;
      }

      const reflections = [
        "Take a moment to reflect on how this verse speaks to your heart today. God's word is living and active, meeting us exactly where we are.",
        "Let this verse settle into your spirit. Sometimes the simplest truths carry the deepest meaning for our daily walk.",
        "Consider how you can apply this truth in your life today. God's promises are new every morning, and His faithfulness is great.",
        "Meditate on these words throughout your day. Allow the Holy Spirit to reveal new depths of understanding.",
        "This verse reminds us of God's unchanging love. Let it be an anchor for your soul today.",
      ];

      const reflection = reflections[Math.floor(Math.random() * reflections.length)]!;

      await db.insert(dailyVersesTable).values({
        verseId: randomVerse[0]!.id,
        reflection,
        date: today!,
      });

      res.json({
        verse: randomVerse[0],
        reflection,
        date: today,
      });
      return;
    }

    const verse = await db
      .select()
      .from(versesTable)
      .where(eq(versesTable.id, daily[0]!.verseId))
      .limit(1);

    res.json({
      verse: verse[0],
      reflection: daily[0]!.reflection,
      date: daily[0]!.date,
    });
  } catch (error) {
    console.error("Error getting daily verse:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/verses", async (req, res) => {
  try {
    const { book, chapter } = req.query;
    const limit = clampInt(req.query.limit, 20, 1, 200);
    const offset = clampInt(req.query.offset, 0, 0, 100000);

    const conditions = [];
    if (book && typeof book === "string") conditions.push(eq(versesTable.book, book));
    if (chapter) {
      const ch = Number(chapter);
      if (!isNaN(ch) && ch > 0) conditions.push(eq(versesTable.chapter, ch));
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    let verses = await db
      .select()
      .from(versesTable)
      .where(whereClause)
      .limit(limit)
      .offset(offset)
      .orderBy(versesTable.verseNumber);

    if (verses.length < 10 && book && typeof book === "string" && chapter) {
      const ch = Number(chapter);
      if (!isNaN(ch) && ch > 0) {
        const fetched = await fetchAndCacheVerses(book, ch);
        if (fetched.length > 0) {
          verses = await db
            .select()
            .from(versesTable)
            .where(and(eq(versesTable.book, book), eq(versesTable.chapter, ch)))
            .orderBy(versesTable.verseNumber);
        }
      }
    }

    const countResult = await db
      .select({ count: sql<number>`count(*)` })
      .from(versesTable)
      .where(whereClause);

    res.json({
      verses,
      total: Number(countResult[0]?.count ?? 0),
    });
  } catch (error) {
    console.error("Error getting verses:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/verses/:id", async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (isNaN(id) || id <= 0) {
      res.status(400).json({ error: "Invalid verse ID" });
      return;
    }

    const verse = await db
      .select()
      .from(versesTable)
      .where(eq(versesTable.id, id))
      .limit(1);

    if (verse.length === 0) {
      res.status(404).json({ error: "Verse not found" });
      return;
    }

    res.json(verse[0]);
  } catch (error) {
    console.error("Error getting verse:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/books", async (_req, res) => {
  try {
    const books = await db
      .select()
      .from(booksTable)
      .orderBy(booksTable.ordering);

    res.json({
      books: books.map((b) => ({
        name: b.name,
        testament: b.testament,
        chapters: b.chapters,
      })),
    });
  } catch (error) {
    console.error("Error getting books:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;

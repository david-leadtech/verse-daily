import { db } from "@workspace/db";
import { versesTable, booksTable } from "@workspace/db/schema";
import { eq, and, sql } from "drizzle-orm";

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

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function downloadBible() {
  console.log("Starting full KJV Bible download...\n");

  const books = await db.select().from(booksTable).orderBy(booksTable.ordering);
  console.log(`Found ${books.length} books in database\n`);

  let totalVersesInserted = 0;
  let totalChaptersProcessed = 0;
  let errors: string[] = [];

  for (const book of books) {
    const existingCount = await db
      .select({ count: sql<number>`count(*)` })
      .from(versesTable)
      .where(eq(versesTable.book, book.name));

    const currentCount = Number(existingCount[0]?.count ?? 0);

    console.log(`\n📖 ${book.name} (${book.chapters} chapters, ${currentCount} verses already in DB)`);

    for (let chapter = 1; chapter <= book.chapters; chapter++) {
      const chapterExists = await db
        .select({ count: sql<number>`count(*)` })
        .from(versesTable)
        .where(and(eq(versesTable.book, book.name), eq(versesTable.chapter, chapter)));

      const chapterCount = Number(chapterExists[0]?.count ?? 0);

      if (chapterCount >= 5) {
        process.stdout.write(".");
        totalChaptersProcessed++;
        continue;
      }

      const apiBookName = BOOK_API_NAMES[book.name] || book.name;
      const url = `https://bible-api.com/${encodeURIComponent(apiBookName)}+${chapter}?translation=kjv`;

      try {
        const response = await fetch(url, { signal: AbortSignal.timeout(15000) });

        if (!response.ok) {
          errors.push(`${book.name} ${chapter}: HTTP ${response.status}`);
          process.stdout.write("X");
          await sleep(500);
          continue;
        }

        const data = await response.json() as {
          verses?: Array<{ book_name: string; chapter: number; verse: number; text: string }>;
        };

        if (!data.verses || data.verses.length === 0) {
          errors.push(`${book.name} ${chapter}: No verses in response`);
          process.stdout.write("X");
          await sleep(300);
          continue;
        }

        if (chapterCount > 0) {
          await db.delete(versesTable).where(
            and(eq(versesTable.book, book.name), eq(versesTable.chapter, chapter))
          );
        }

        const versesToInsert = data.verses.map((v) => ({
          book: book.name,
          chapter: v.chapter,
          verseNumber: v.verse,
          text: v.text.replace(/\n/g, " ").trim(),
          version: "KJV" as const,
        }));

        await db.insert(versesTable).values(versesToInsert);
        totalVersesInserted += versesToInsert.length;
        totalChaptersProcessed++;
        process.stdout.write(`✓`);

        await sleep(200);
      } catch (err: any) {
        errors.push(`${book.name} ${chapter}: ${err.message}`);
        process.stdout.write("X");
        await sleep(1000);
      }
    }
  }

  console.log(`\n\n${"=".repeat(50)}`);
  console.log(`Download complete!`);
  console.log(`Chapters processed: ${totalChaptersProcessed}`);
  console.log(`Verses inserted: ${totalVersesInserted}`);

  const finalCount = await db.select({ count: sql<number>`count(*)` }).from(versesTable);
  console.log(`Total verses in database: ${Number(finalCount[0]?.count ?? 0)}`);

  if (errors.length > 0) {
    console.log(`\nErrors (${errors.length}):`);
    errors.forEach((e) => console.log(`  - ${e}`));
  }

  process.exit(0);
}

downloadBible().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});

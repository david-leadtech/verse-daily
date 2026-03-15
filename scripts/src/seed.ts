import { db, eq, and, sql } from "@workspace/db";
import { versesTable, booksTable, devotionalsTable, dailyVersesTable } from "@workspace/db/schema";

const GITHUB_FILE_NAMES: Record<string, string> = {
  "1 Samuel": "1Samuel",
  "2 Samuel": "2Samuel",
  "1 Kings": "1Kings",
  "2 Kings": "2Kings",
  "1 Chronicles": "1Chronicles",
  "2 Chronicles": "2Chronicles",
  "Song of Solomon": "SongofSolomon",
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

interface BibleBookJSON {
  book: string;
  chapters: Array<{
    chapter: number;
    verses: Array<{ verse: string; text: string }>;
  }>;
}

async function downloadFullBible(books: Array<{ name: string; chapters: number }>) {
  console.log("\nDownloading full KJV Bible...");
  let totalInserted = 0;
  let errors: string[] = [];

  for (const book of books) {
    const githubName = GITHUB_FILE_NAMES[book.name] || book.name;
    const url = `https://raw.githubusercontent.com/aruljohn/Bible-kjv/master/${githubName}.json`;

    try {
      const res = await fetch(url, { signal: AbortSignal.timeout(30000) });
      if (!res.ok) {
        errors.push(`${book.name}: HTTP ${res.status}`);
        console.log(`  ✗ ${book.name} (HTTP ${res.status})`);
        continue;
      }

      const data = (await res.json()) as BibleBookJSON;

      if (!data.chapters || data.chapters.length === 0) {
        errors.push(`${book.name}: no chapters`);
        console.log(`  ✗ ${book.name} (no chapters)`);
        continue;
      }

      const allVerses: Array<{
        book: string;
        chapter: number;
        verseNumber: number;
        text: string;
        version: string;
      }> = [];

      for (const ch of data.chapters) {
        for (const v of ch.verses) {
          allVerses.push({
            book: book.name,
            chapter: ch.chapter,
            verseNumber: parseInt(v.verse, 10),
            text: v.text.trim(),
            version: "KJV",
          });
        }
      }

      await db.delete(versesTable).where(eq(versesTable.book, book.name));

      const BATCH_SIZE = 500;
      for (let i = 0; i < allVerses.length; i += BATCH_SIZE) {
        const batch = allVerses.slice(i, i + BATCH_SIZE);
        await db.insert(versesTable).values(batch);
      }

      totalInserted += allVerses.length;
      console.log(`  ✓ ${book.name}: ${data.chapters.length} chapters, ${allVerses.length} verses`);

      await sleep(100);
    } catch (err: any) {
      errors.push(`${book.name}: ${err.message}`);
      console.log(`  ✗ ${book.name}: ${err.message}`);
      await sleep(500);
    }
  }

  const finalCount = await db.select({ count: sql<number>`count(*)` }).from(versesTable);
  console.log(`\nBible download complete!`);
  console.log(`Total verses inserted: ${totalInserted}`);
  console.log(`Total verses in database: ${Number(finalCount[0]?.count ?? 0)}`);

  if (errors.length > 0) {
    console.log(`\nErrors (${errors.length}):`);
    errors.forEach((e) => console.log(`  - ${e}`));
  }
}

async function seed() {
  console.log("Seeding database...");

  await db.delete(dailyVersesTable);
  await db.delete(devotionalsTable);
  await db.delete(versesTable);
  await db.delete(booksTable);

  const books = [
    { name: "Genesis", testament: "Old Testament", chapters: 50, ordering: 1 },
    { name: "Exodus", testament: "Old Testament", chapters: 40, ordering: 2 },
    { name: "Leviticus", testament: "Old Testament", chapters: 27, ordering: 3 },
    { name: "Numbers", testament: "Old Testament", chapters: 36, ordering: 4 },
    { name: "Deuteronomy", testament: "Old Testament", chapters: 34, ordering: 5 },
    { name: "Joshua", testament: "Old Testament", chapters: 24, ordering: 6 },
    { name: "Judges", testament: "Old Testament", chapters: 21, ordering: 7 },
    { name: "Ruth", testament: "Old Testament", chapters: 4, ordering: 8 },
    { name: "1 Samuel", testament: "Old Testament", chapters: 31, ordering: 9 },
    { name: "2 Samuel", testament: "Old Testament", chapters: 24, ordering: 10 },
    { name: "1 Kings", testament: "Old Testament", chapters: 22, ordering: 11 },
    { name: "2 Kings", testament: "Old Testament", chapters: 25, ordering: 12 },
    { name: "1 Chronicles", testament: "Old Testament", chapters: 29, ordering: 13 },
    { name: "2 Chronicles", testament: "Old Testament", chapters: 36, ordering: 14 },
    { name: "Ezra", testament: "Old Testament", chapters: 10, ordering: 15 },
    { name: "Nehemiah", testament: "Old Testament", chapters: 13, ordering: 16 },
    { name: "Esther", testament: "Old Testament", chapters: 10, ordering: 17 },
    { name: "Job", testament: "Old Testament", chapters: 42, ordering: 18 },
    { name: "Psalms", testament: "Old Testament", chapters: 150, ordering: 19 },
    { name: "Proverbs", testament: "Old Testament", chapters: 31, ordering: 20 },
    { name: "Ecclesiastes", testament: "Old Testament", chapters: 12, ordering: 21 },
    { name: "Song of Solomon", testament: "Old Testament", chapters: 8, ordering: 22 },
    { name: "Isaiah", testament: "Old Testament", chapters: 66, ordering: 23 },
    { name: "Jeremiah", testament: "Old Testament", chapters: 52, ordering: 24 },
    { name: "Lamentations", testament: "Old Testament", chapters: 5, ordering: 25 },
    { name: "Ezekiel", testament: "Old Testament", chapters: 48, ordering: 26 },
    { name: "Daniel", testament: "Old Testament", chapters: 12, ordering: 27 },
    { name: "Hosea", testament: "Old Testament", chapters: 14, ordering: 28 },
    { name: "Joel", testament: "Old Testament", chapters: 3, ordering: 29 },
    { name: "Amos", testament: "Old Testament", chapters: 9, ordering: 30 },
    { name: "Obadiah", testament: "Old Testament", chapters: 1, ordering: 31 },
    { name: "Jonah", testament: "Old Testament", chapters: 4, ordering: 32 },
    { name: "Micah", testament: "Old Testament", chapters: 7, ordering: 33 },
    { name: "Nahum", testament: "Old Testament", chapters: 3, ordering: 34 },
    { name: "Habakkuk", testament: "Old Testament", chapters: 3, ordering: 35 },
    { name: "Zephaniah", testament: "Old Testament", chapters: 3, ordering: 36 },
    { name: "Haggai", testament: "Old Testament", chapters: 2, ordering: 37 },
    { name: "Zechariah", testament: "Old Testament", chapters: 14, ordering: 38 },
    { name: "Malachi", testament: "Old Testament", chapters: 4, ordering: 39 },
    { name: "Matthew", testament: "New Testament", chapters: 28, ordering: 40 },
    { name: "Mark", testament: "New Testament", chapters: 16, ordering: 41 },
    { name: "Luke", testament: "New Testament", chapters: 24, ordering: 42 },
    { name: "John", testament: "New Testament", chapters: 21, ordering: 43 },
    { name: "Acts", testament: "New Testament", chapters: 28, ordering: 44 },
    { name: "Romans", testament: "New Testament", chapters: 16, ordering: 45 },
    { name: "1 Corinthians", testament: "New Testament", chapters: 16, ordering: 46 },
    { name: "2 Corinthians", testament: "New Testament", chapters: 13, ordering: 47 },
    { name: "Galatians", testament: "New Testament", chapters: 6, ordering: 48 },
    { name: "Ephesians", testament: "New Testament", chapters: 6, ordering: 49 },
    { name: "Philippians", testament: "New Testament", chapters: 4, ordering: 50 },
    { name: "Colossians", testament: "New Testament", chapters: 4, ordering: 51 },
    { name: "1 Thessalonians", testament: "New Testament", chapters: 5, ordering: 52 },
    { name: "2 Thessalonians", testament: "New Testament", chapters: 3, ordering: 53 },
    { name: "1 Timothy", testament: "New Testament", chapters: 6, ordering: 54 },
    { name: "2 Timothy", testament: "New Testament", chapters: 4, ordering: 55 },
    { name: "Titus", testament: "New Testament", chapters: 3, ordering: 56 },
    { name: "Philemon", testament: "New Testament", chapters: 1, ordering: 57 },
    { name: "Hebrews", testament: "New Testament", chapters: 13, ordering: 58 },
    { name: "James", testament: "New Testament", chapters: 5, ordering: 59 },
    { name: "1 Peter", testament: "New Testament", chapters: 5, ordering: 60 },
    { name: "2 Peter", testament: "New Testament", chapters: 3, ordering: 61 },
    { name: "1 John", testament: "New Testament", chapters: 5, ordering: 62 },
    { name: "2 John", testament: "New Testament", chapters: 1, ordering: 63 },
    { name: "3 John", testament: "New Testament", chapters: 1, ordering: 64 },
    { name: "Jude", testament: "New Testament", chapters: 1, ordering: 65 },
    { name: "Revelation", testament: "New Testament", chapters: 22, ordering: 66 },
  ];

  await db.insert(booksTable).values(books);
  console.log(`Inserted ${books.length} books`);

  const devotionals = [
    {
      title: "Finding Peace in the Storm",
      content: "Life often brings unexpected storms — moments of uncertainty, fear, and doubt. Yet in the midst of these storms, God offers us His perfect peace. This peace doesn't come from the absence of trouble, but from the presence of God in our lives.\n\nWhen Jesus calmed the storm on the Sea of Galilee, He didn't remove His disciples from the storm first. He was right there with them, speaking peace into their chaos. In the same way, God is with you today, whatever storm you may be facing.\n\nTake a moment to breathe deeply and remember: the One who created the winds and the waves is the same One who holds you in His hands. He has not forgotten you. He is not surprised by your circumstances. And He is working all things together for your good.\n\nPrayer: Lord, I bring my storms to You today. Help me to trust in Your sovereignty and find peace in Your presence. Calm my anxious heart and remind me that You are in control. Amen.",
      verseReference: "John 14:27",
      verseText: "Peace I leave with you, my peace I give unto you: not as the world giveth, give I unto you. Let not your heart be troubled, neither let it be afraid.",
      category: "Peace",
      readTime: 4,
      date: "2026-03-15",
    },
    {
      title: "Strength in Weakness",
      content: "There's a beautiful paradox in the Christian life: when we are weak, we are strong. The world tells us to be self-sufficient, to pull ourselves up by our bootstraps. But God's economy works differently.\n\nPaul discovered this truth through his own suffering. Three times he pleaded with the Lord to remove his thorn in the flesh. God's answer wasn't removal — it was revelation. \"My grace is sufficient for you, for my strength is made perfect in weakness.\"\n\nWhen we acknowledge our weakness, we create space for God's strength to flow through us. It's not about pretending to have it all together. It's about honestly admitting our need and watching God show up in powerful ways.\n\nToday, instead of hiding your struggles, bring them to God. Let His grace meet you exactly where you are.\n\nPrayer: Father, I confess my weakness before You. Thank You that Your grace is enough. Fill me with Your strength today. Let my life be a testimony of Your power at work in human frailty. Amen.",
      verseReference: "2 Corinthians 12:9",
      verseText: "And he said unto me, My grace is sufficient for thee: for my strength is made perfect in weakness.",
      category: "Strength",
      readTime: 5,
      date: "2026-03-14",
    },
    {
      title: "Walking by Faith",
      content: "Faith is not the absence of questions — it's the decision to trust God even when we don't have all the answers. The Bible tells us to walk by faith, not by sight. But what does that look like in everyday life?\n\nIt looks like trusting God with your finances when the numbers don't add up. It looks like believing in His plan when your own plans have fallen apart. It looks like choosing hope when the world gives you every reason to despair.\n\nAbraham walked by faith when he left his homeland without knowing where he was going. Moses walked by faith when he stood before Pharaoh with nothing but a staff and a word from God. And we are called to walk that same road of faith today.\n\nThe beautiful thing about faith is that it grows. Every step you take in trust becomes the foundation for the next one.\n\nPrayer: God, increase my faith today. Help me to trust You more deeply and walk more boldly. When I cannot see the path ahead, let me rest in the knowledge that You can. Amen.",
      verseReference: "2 Corinthians 5:7",
      verseText: "For we walk by faith, not by sight.",
      category: "Faith",
      readTime: 5,
      date: "2026-03-13",
    },
    {
      title: "The Gift of Grace",
      content: "Grace. It's one of the most powerful words in the Christian vocabulary, yet one of the hardest to truly grasp. Grace is getting what we don't deserve — the unmerited favor of a holy God poured out on imperfect people.\n\nWe live in a world that operates on merit. You earn your salary. You earn your grades. You earn respect. But grace shatters that system entirely. You cannot earn God's love. You already have it.\n\nEphesians 2:8 reminds us that salvation is a gift — not something we can achieve through our own efforts. This truth should humble us and free us at the same time. We don't have to perform for God's approval. We don't have to be perfect to be loved.\n\nLet grace wash over you today. Receive it. Rest in it. And then extend it to others.\n\nPrayer: Heavenly Father, thank You for the gift of grace that I could never earn or deserve. Help me to live in the freedom of Your grace and to show that same grace to everyone I meet today. Amen.",
      verseReference: "Ephesians 2:8",
      verseText: "For by grace are ye saved through faith; and that not of yourselves: it is the gift of God.",
      category: "Grace",
      readTime: 4,
      date: "2026-03-12",
    },
    {
      title: "Trusting God's Timing",
      content: "Waiting is hard. Whether you're waiting for a prayer to be answered, a door to open, or a season to change, the waiting can feel endless. But God's timing is perfect — even when it doesn't align with our timeline.\n\nIsaiah 40:31 promises that those who wait upon the Lord will renew their strength. Notice it doesn't say \"those who rush ahead\" or \"those who figure it out on their own.\" There is supernatural strength available to those who are willing to wait.\n\nGod is not slow. He is not forgetful. He is sovereign and intentional. Every delay has a purpose. Every waiting season is producing something in you that couldn't be produced any other way — patience, character, endurance, and a deeper dependence on Him.\n\nToday, choose to trust His timing. Release your grip on the calendar and let God be God.\n\nPrayer: Lord, I surrender my timeline to You. Give me patience in the waiting and peace in the not knowing. I trust that Your timing is perfect. Amen.",
      verseReference: "Isaiah 40:31",
      verseText: "But they that wait upon the Lord shall renew their strength; they shall mount up with wings as eagles; they shall run, and not be weary; and they shall walk, and not faint.",
      category: "Trust",
      readTime: 5,
      date: "2026-03-11",
    },
    {
      title: "The Power of Prayer",
      content: "Prayer is not a last resort — it's the first response of a heart that knows God. James tells us that if we lack wisdom, we should ask God, who gives generously without finding fault. What an invitation!\n\nPrayer changes things. But more importantly, prayer changes us. When we come before God with our needs, our fears, our gratitude, and our worship, something shifts inside us. We remember who He is. We remember who we are in Him.\n\nYou don't need fancy words to pray. You don't need to pray for a certain amount of time. You just need an honest heart and a willingness to talk to the One who already knows everything about you and loves you completely.\n\nMake prayer your first language today. Before you text a friend, text God (so to speak). Before you Google the answer, ask the One who knows all things.\n\nPrayer: Father, teach me to pray. Help me to come to You first in every situation. Thank You that You hear me, You know me, and You answer in Your perfect way. Amen.",
      verseReference: "James 1:5",
      verseText: "If any of you lack wisdom, let him ask of God, that giveth to all men liberally, and upbraideth not; and it shall be given him.",
      category: "Prayer",
      readTime: 4,
      date: "2026-03-10",
    },
    {
      title: "God's Unfailing Love",
      content: "In a world where love often feels conditional — based on performance, appearance, or what you can offer — God's love stands in stunning contrast. His love is unfailing, unconditional, and unending.\n\nRomans 8:38-39 declares that nothing can separate us from the love of God. Not death. Not life. Not angels or demons. Not the present or the future. Not height or depth. Not anything in all creation. Nothing.\n\nLet that sink in for a moment. There is nothing you could do to make God love you more. And there is nothing you could do to make God love you less. His love is not a reward for your goodness — it's a reflection of His nature.\n\nWhatever you're carrying today — guilt, shame, fear, doubt — bring it to the One whose love covers it all.\n\nPrayer: Lord, help me to truly believe in Your unfailing love. Remove the lies that tell me I'm not enough and replace them with the truth of who I am in You. I receive Your love today. Amen.",
      verseReference: "Romans 8:38-39",
      verseText: "For I am persuaded, that neither death, nor life, nor angels, nor principalities, nor powers, nor things present, nor things to come, nor height, nor depth, nor any other creature, shall be able to separate us from the love of God, which is in Christ Jesus our Lord.",
      category: "Love",
      readTime: 4,
      date: "2026-03-09",
    },
    {
      title: "Living with Purpose",
      content: "You are not an accident. You are not a cosmic coincidence. You were created with intention, designed with purpose, and placed in this moment in history for a reason.\n\nPhilippians 1:6 assures us that God, who began a good work in us, will carry it on to completion. He's not finished with you yet. Every experience you've had — every joy, every heartbreak, every triumph, every failure — is being woven into a story only you can tell.\n\nPurpose doesn't always mean doing something grand in the world's eyes. Sometimes purpose looks like being faithful in the small things. Loving your neighbor. Being honest at work. Raising your children with patience. Showing kindness to a stranger.\n\nToday, walk in the confidence that your life matters. God has a purpose for this day, and He's inviting you to be part of it.\n\nPrayer: God, reveal Your purpose for my life today. Help me to see the opportunities You've placed before me and give me the courage to walk in them. I trust that You are completing the good work You started in me. Amen.",
      verseReference: "Philippians 1:6",
      verseText: "Being confident of this very thing, that he which hath begun a good work in you will perform it until the day of Jesus Christ.",
      category: "Purpose",
      readTime: 5,
      date: "2026-03-08",
    },
    {
      title: "Overcoming Fear",
      content: "Fear is one of the enemy's favorite tools. It whispers lies in the dark: \"You're not enough.\" \"What if it all falls apart?\" \"You can't do this.\" But God's Word speaks a different truth.\n\n2 Timothy 1:7 tells us that God has not given us a spirit of fear, but of power, love, and a sound mind. Fear does not come from God. It is not His voice, and it is not your destiny.\n\nEvery time fear rises up, you have a choice: believe the fear or believe the Father. And every time you choose faith over fear, you grow stronger. The fears don't necessarily go away, but they lose their grip on you.\n\nRemember: courage is not the absence of fear. Courage is moving forward in spite of it, knowing that the God who goes before you is greater than anything that stands against you.\n\nPrayer: Lord, I reject the spirit of fear and receive Your spirit of power, love, and a sound mind. Help me to face today's challenges with courage and confidence in You. Amen.",
      verseReference: "2 Timothy 1:7",
      verseText: "For God hath not given us the spirit of fear; but of power, and of love, and of a sound mind.",
      category: "Courage",
      readTime: 5,
      date: "2026-03-07",
    },
    {
      title: "Gratitude Changes Everything",
      content: "There's something transformative about gratitude. When we choose to give thanks — even in difficult circumstances — our perspective shifts. Problems that seemed insurmountable begin to shrink in the light of God's goodness.\n\n1 Thessalonians 5:16-18 gives us three short but powerful commands: Rejoice always. Pray continually. Give thanks in all circumstances. Notice it says \"in\" all circumstances, not \"for\" all circumstances. We don't have to be thankful for the pain, but we can be thankful in the pain, because we know God is with us.\n\nGratitude is a discipline that becomes a delight. Start small. Thank God for your next breath. For the sunlight. For the people He's placed in your life. Watch how a grateful heart changes the way you see everything.\n\nPrayer: Father, forgive me for the times I've focused on what I lack instead of what I have. Open my eyes to Your blessings today. Fill my heart with genuine gratitude and let it overflow to everyone around me. Amen.",
      verseReference: "1 Thessalonians 5:16-18",
      verseText: "Rejoice evermore. Pray without ceasing. In every thing give thanks: for this is the will of God in Christ Jesus concerning you.",
      category: "Gratitude",
      readTime: 4,
      date: "2026-03-06",
    },
  ];

  await db.insert(devotionalsTable).values(devotionals);
  console.log(`Inserted ${devotionals.length} devotionals`);

  await downloadFullBible(books);

  console.log("\nSeeding complete!");
}

seed()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error("Seed error:", err);
    process.exit(1);
  });

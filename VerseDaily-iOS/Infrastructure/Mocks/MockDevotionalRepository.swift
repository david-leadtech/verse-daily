import Foundation

public final class MockDevotionalRepository: DevotionalRepositoryProtocol {
    // Rotating selection of meaningful verses for different days
    private let dailyVerses = [
        (book: "John", chapter: 3, verse: 16),
        (book: "Psalm", chapter: 23, verse: 1),
        (book: "Romans", chapter: 8, verse: 28),
        (book: "Proverbs", chapter: 3, verse: 5),
        (book: "1 John", chapter: 4, verse: 7),
        (book: "Matthew", chapter: 5, verse: 14),
        (book: "Philippians", chapter: 4, verse: 13),
        (book: "Jeremiah", chapter: 29, verse: 11),
    ]

    public init() {}

    public func getDailyVerse() async throws -> DailyVerse {
        // Rotate through verses based on day of year
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let verseData = dailyVerses[dayOfYear % dailyVerses.count]

        let verse = Verse(
            id: dayOfYear,
            book: verseData.book,
            chapter: verseData.chapter,
            verseNumber: verseData.verse,
            text: getVerseText(book: verseData.book, chapter: verseData.chapter, verse: verseData.verse),
            version: "KJV"
        )
        return DailyVerse(
            verse: verse,
            reflection: getReflection(book: verseData.book, chapter: verseData.chapter, verse: verseData.verse)
        )
    }

    private func getVerseText(book: String, chapter: Int, verse: Int) -> String {
        // Sample verse texts - in production, would come from BibleData.json
        switch (book, chapter, verse) {
        case ("John", 3, 16):
            return "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life."
        case ("Psalm", 23, 1):
            return "The LORD is my shepherd; I shall not want."
        case ("Romans", 8, 28):
            return "And we know that all things work together for good to them that love God, to them who are the called according to his purpose."
        case ("Proverbs", 3, 5):
            return "Trust in the LORD with all thine heart; and lean not unto thine own understanding."
        case ("1 John", 4, 7):
            return "Beloved, let us love one another: for love is of God; and every one that loveth is born of God, and knoweth God."
        case ("Matthew", 5, 14):
            return "Ye are the light of the world. A city that is set on an hill cannot be hid."
        case ("Philippians", 4, 13):
            return "I can do all things through Christ which strengtheneth me."
        case ("Jeremiah", 29, 11):
            return "For I know the thoughts that I think toward you, saith the LORD, thoughts of peace, and not of evil, to give you an expected end."
        default:
            return "Seek ye first the kingdom of God, and his righteousness; and all these things shall be added unto you."
        }
    }

    private func getReflection(book: String, chapter: Int, verse: Int) -> String {
        switch (book, chapter, verse) {
        case ("John", 3, 16):
            return "God's love for us is infinite and sacrificial. Through Jesus, we find the path to eternal life and a relationship with our Creator that transcends our earthly struggles."
        case ("Psalm", 23, 1):
            return "The Lord provides guidance and protection for those who trust in Him. Rest in His care and leadership."
        case ("Romans", 8, 28):
            return "Even in difficult circumstances, God's purpose works for the good of those who love Him. Hold onto faith during challenges."
        case ("Proverbs", 3, 5):
            return "Seek God's wisdom in all decisions. Not our understanding, but His guidance leads to the right path."
        case ("1 John", 4, 7):
            return "Love is the foundation of our faith. By loving one another, we reflect God's nature and draw closer to Him."
        case ("Matthew", 5, 14):
            return "Your life is a testimony to God's grace. Let your actions and faith shine brightly for others to see Christ."
        case ("Philippians", 4, 13):
            return "Christ gives us the strength to overcome any obstacle. Lean on Him in times of weakness and doubt."
        case ("Jeremiah", 29, 11):
            return "God has a purpose and hope-filled plan for your life. Trust His timing and direction for your future."
        default:
            return "Meditate on God's Word and allow it to transform your thoughts and actions."
        }
    }
    
    public func getDevotionals(limit: Int) async throws -> [Devotional] {
        return [
            Devotional(id: 1, title: "Finding Peace in the Storm", category: "Peace", readTime: "3 min", verseReference: "Mark 4:39"),
            Devotional(id: 2, title: "Walking by Faith", category: "Faith", readTime: "4 min", verseReference: "2 Corinthians 5:7"),
            Devotional(id: 3, title: "The Power of Forgiveness", category: "Growth", readTime: "5 min", verseReference: "Colossians 3:13")
        ]
    }
    
    public func getDevotional(id: Int) async throws -> Devotional {
        return Devotional(id: id, title: "Sample Devotional", category: "Sample", readTime: "5 min", verseReference: "Psalm 23:1", content: "This is the full content of the devotional for testing purposes.")
    }
    
    public func searchDevotionals(query: String) async throws -> [Devotional] {
        return []
    }
}

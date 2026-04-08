import Foundation

public final class MockDevotionalRepository: DevotionalRepositoryProtocol {
    public init() {}
    
    public func getDailyVerse() async throws -> DailyVerse {
        let verse = Verse(
            id: 1,
            book: "John",
            chapter: 3,
            verseNumber: 16,
            text: "For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.",
            version: "KJV"
        )
        return DailyVerse(verse: verse, reflection: "God's love for us is infinite and sacrificial. Through Jesus, we find the path to eternal life and a relationship with our Creator that transcends our earthly struggles.")
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

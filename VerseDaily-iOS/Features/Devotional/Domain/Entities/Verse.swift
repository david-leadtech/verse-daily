import Foundation

public struct Verse: Identifiable, Codable, Sendable, Equatable {
    public let id: Int
    public let book: String
    public let chapter: Int
    public let verseNumber: Int
    public let text: String
    public let version: String
    
    public init(id: Int, book: String, chapter: Int, verseNumber: Int, text: String, version: String) {
        self.id = id
        self.book = book
        self.chapter = chapter
        self.verseNumber = verseNumber
        self.text = text
        self.version = version
    }
    
    public var reference: String {
        "\(book) \(chapter):\(verseNumber)"
    }
}

public struct DailyVerse: Sendable, Equatable {
    public let verse: Verse
    public let reflection: String?
    public let date: Date
    
    public init(verse: Verse, reflection: String?, date: Date = Date()) {
        self.verse = verse
        self.reflection = reflection
        self.date = date
    }
}

import Foundation
import SwiftData

/// Records when and how long a verse was read
/// Used for reading history and streak tracking
@Model
public final class ReadingRecord {
    @Attribute(.unique) public var id: String
    public var verseId: String
    public var book: String
    public var chapter: Int
    public var verseNumber: Int
    public var readAt: Date
    public var duration: TimeInterval

    public init(
        id: String = UUID().uuidString,
        verseId: String,
        book: String,
        chapter: Int,
        verseNumber: Int,
        readAt: Date = Date(),
        duration: TimeInterval = 0
    ) {
        self.id = id
        self.verseId = verseId
        self.book = book
        self.chapter = chapter
        self.verseNumber = verseNumber
        self.readAt = readAt
        self.duration = duration
    }
}

import Foundation
import SwiftData

/// Represents a user's reading session for a Bible chapter
/// Tracks reading progress and helps resume from where the user left off
@Model
public final class ReadingSession {
    @Attribute(.unique) public var id: String
    public var book: String
    public var chapter: Int
    public var lastVerseRead: Int
    public var startedAt: Date
    public var lastReadAt: Date
    public var readDuration: TimeInterval

    public init(
        id: String = UUID().uuidString,
        book: String,
        chapter: Int,
        lastVerseRead: Int = 0,
        startedAt: Date = Date(),
        lastReadAt: Date = Date(),
        readDuration: TimeInterval = 0
    ) {
        self.id = id
        self.book = book
        self.chapter = chapter
        self.lastVerseRead = lastVerseRead
        self.startedAt = startedAt
        self.lastReadAt = lastReadAt
        self.readDuration = readDuration
    }

    /// Percentage of chapter read
    public var readPercentage: Double {
        guard lastVerseRead > 0 else { return 0 }
        // Will be set based on total verses in chapter from ViewModel
        return Double(lastVerseRead) / 100.0 // Default; should be overridden with actual verse count
    }

    /// Whether the chapter is fully completed
    public var isCompleted: Bool {
        readPercentage >= 1.0
    }
}

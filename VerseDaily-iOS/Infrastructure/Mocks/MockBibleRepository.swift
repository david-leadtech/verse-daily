import Foundation
import SharedKernel

public final class MockBibleRepository: BibleRepositoryProtocol {
    public init() {}
    
    public func getBooks() async throws -> [BibleBook] {
        return [
            BibleBook(name: "Genesis", testament: .old, chapters: 50),
            BibleBook(name: "Exodus", testament: .old, chapters: 40),
            BibleBook(name: "Matthew", testament: .new, chapters: 28),
            BibleBook(name: "John", testament: .new, chapters: 21)
        ]
    }
    
    public func getVerses(book: String, chapter: Int) async throws -> [Verse] {
        return [
            Verse(id: 1, book: book, chapter: chapter, verseNumber: 1, text: "In the beginning...", version: "KJV"),
            Verse(id: 2, book: book, chapter: chapter, verseNumber: 2, text: "And the earth was without form...", version: "KJV")
        ]
    }
    
    public func search(query: String) async throws -> [Verse] {
        return []
    }
}

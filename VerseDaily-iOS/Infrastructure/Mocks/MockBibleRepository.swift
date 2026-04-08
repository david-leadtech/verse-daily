import Foundation

public final class MockBibleRepository: BibleRepositoryProtocol {
    private let books: [BibleBook]

    public init() {
        self.books = Self.loadBooksFromJSON()
    }

    private static func loadBooksFromJSON() -> [BibleBook] {
        guard let url = Bundle.main.url(forResource: "BibleData", withExtension: "json") else {
            return Self.fallbackBooks()
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let bibleDictionary = try decoder.decode([String: [BibleBook]].self, from: data)
            return bibleDictionary["books"] ?? Self.fallbackBooks()
        } catch {
            print("Error loading BibleData.json: \(error)")
            return Self.fallbackBooks()
        }
    }

    private static func fallbackBooks() -> [BibleBook] {
        return [
            BibleBook(name: "Genesis", testament: .old, chapters: 50),
            BibleBook(name: "Exodus", testament: .old, chapters: 40),
            BibleBook(name: "Matthew", testament: .new, chapters: 28),
            BibleBook(name: "John", testament: .new, chapters: 21)
        ]
    }

    public func getBooks() async throws -> [BibleBook] {
        return books
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

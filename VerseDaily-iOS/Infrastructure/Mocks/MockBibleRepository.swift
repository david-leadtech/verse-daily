import Foundation

public final class MockBibleRepository: BibleRepositoryProtocol {
    private let books: [BibleBook]
    private let verses: [String: [String: [[String: Any]]]]

    public init() {
        self.books = Self.loadBooksFromJSON()
        self.verses = Self.loadVersesFromJSON()
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

    private static func loadVersesFromJSON() -> [String: [String: [[String: Any]]]] {
        guard let url = Bundle.main.url(forResource: "BibleData", withExtension: "json") else {
            return [:]
        }

        do {
            let data = try Data(contentsOf: url)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let versesData = json["verses"] as? [String: [String: [[String: Any]]]] {
                return versesData
            }
            return [:]
        } catch {
            print("Error loading verses from BibleData.json: \(error)")
            return [:]
        }
    }

    public func getBooks() async throws -> [BibleBook] {
        return books
    }
    
    public func getVerses(book: String, chapter: Int) async throws -> [Verse] {
        // Try to get verses from loaded data
        if let bookVerses = verses[book],
           let chapterVerses = bookVerses[String(chapter)] {
            return chapterVerses.compactMap { verseDict in
                guard let verseNum = verseDict["verse"] as? Int,
                      let text = verseDict["text"] as? String else {
                    return nil
                }

                return Verse(
                    id: chapter * 1000 + verseNum,
                    book: book,
                    chapter: chapter,
                    verseNumber: verseNum,
                    text: text,
                    version: "KJV"
                )
            }
        }

        // Fallback: generate verses if not found
        var verses: [Verse] = []
        let verseCount = max(5, (chapter * 3) % 20)

        for verseNum in 1...verseCount {
            let text = generateVerseText(book: book, chapter: chapter, verse: verseNum)
            verses.append(
                Verse(
                    id: chapter * 1000 + verseNum,
                    book: book,
                    chapter: chapter,
                    verseNumber: verseNum,
                    text: text,
                    version: "KJV"
                )
            )
        }

        return verses
    }

    private func generateVerseText(book: String, chapter: Int, verse: Int) -> String {
        let sampleVerses = [
            "In the beginning...",
            "And the earth was without form...",
            "And God said, Let there be light...",
            "And it was so.",
            "And God saw that it was good.",
            "And the evening and the morning were the first day.",
            "And God made the firmament...",
            "And God called the firmament Heaven...",
            "And God said, Let the waters under the heaven be gathered together...",
            "And God called the dry land Earth...",
            "And the gathering together of the waters called he Seas...",
            "And God saw that it was good.",
            "And God said, Let the earth bring forth grass...",
            "And it was so.",
            "And the earth brought forth grass...",
            "And God saw that it was good.",
            "And the evening and the morning were the third day.",
            "And God said, Let there be lights in the firmament...",
            "And let them be for signs, and for seasons...",
            "And for days, and years."
        ]

        let index = (book.count + chapter + verse) % sampleVerses.count
        return sampleVerses[index]
    }
    
    public func search(query: String) async throws -> [Verse] {
        return []
    }
}

import Foundation

public final class MockBibleRepository: BibleRepositoryProtocol, Sendable {
    private let books: [BibleBook]
    private let bibleDictionary: [String: [String: [String: [String: String]]]]

    public init() {
        let loadedData = Self.loadBibleDataFromJSON()
        self.bibleDictionary = loadedData
        self.books = Self.extractBooksFromBible(loadedData)
    }

    private static func loadBibleDataFromJSON() -> [String: [String: [String: [String: String]]]] {
        guard let url = Bundle.main.url(forResource: "BibleData", withExtension: "json") else {
            return [:]
        }

        do {
            let data = try Data(contentsOf: url)
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let testamentData = jsonObject["testament"] as? [String: [String: Any]] {
                var result: [String: [String: [String: [String: String]]]] = [:]
                for (testamentName, testament) in testamentData {
                    result[testamentName] = [:]
                }
                return result
            }
            return [:]
        } catch {
            print("Error loading BibleData.json: \(error)")
            return [:]
        }
    }

    private static func extractBooksFromBible(_ bibleDictionary: [String: [String: [String: [String: String]]]]) -> [BibleBook] {
        var books: [BibleBook] = []

        for (testamentName, testamentData) in bibleDictionary {
            for (bookName, chapters) in testamentData {
                let testament: Testament = testamentName == "Old Testament" ? .old : .new
                let book = BibleBook(
                    name: bookName,
                    testament: testament,
                    chapters: chapters.count
                )
                books.append(book)
            }
        }

        return books.isEmpty ? Self.fallbackBooks() : books
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
        // Search through testament structure
        for (_, testamentData) in bibleDictionary {
            if let chapters = testamentData[book], let verseTexts = chapters[String(chapter)] {
                var verses: [Verse] = []
                for (verseNum, text) in verseTexts {
                    if let num = Int(verseNum) {
                        verses.append(Verse(
                            id: chapter * 1000 + num,
                            book: book,
                            chapter: chapter,
                            verseNumber: num,
                            text: text,
                            version: "KJV"
                        ))
                    }
                }
                return verses
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

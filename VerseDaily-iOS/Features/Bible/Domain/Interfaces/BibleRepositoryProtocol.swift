import Foundation

public protocol BibleRepositoryProtocol: Sendable {
    func getBooks() async throws -> [BibleBook]
    func getVerses(book: String, chapter: Int) async throws -> [Verse]
    func search(query: String) async throws -> [Verse]
}

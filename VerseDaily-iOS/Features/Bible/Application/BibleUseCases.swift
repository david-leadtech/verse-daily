import Foundation
import SharedKernel

public struct BibleBookDTO: Identifiable, Sendable {
    public var id: String { name }
    public let name: String
    public let testament: String
    public let chapters: Int
    
    public init(name: String, testament: String, chapters: Int) {
        self.name = name
        self.testament = testament
        self.chapters = chapters
    }
}

public final class GetBibleBooksUseCase: Sendable {
    private let repository: BibleRepositoryProtocol
    
    public init(repository: BibleRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [BibleBookDTO] {
        let books = try await repository.getBooks()
        return books.map { 
            BibleBookDTO(name: $0.name, testament: $0.testament.rawValue, chapters: $0.chapters)
        }
    }
}

public final class GetBibleVersesUseCase: Sendable {
    private let repository: BibleRepositoryProtocol
    
    public init(repository: BibleRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(book: String, chapter: Int) async throws -> [VerseDTO] {
        let verses = try await repository.getVerses(book: book, chapter: chapter)
        return verses.map {
            VerseDTO(id: $0.id, Reference: $0.reference, text: $0.text, version: $0.version, reflection: nil)
        }
    }
}

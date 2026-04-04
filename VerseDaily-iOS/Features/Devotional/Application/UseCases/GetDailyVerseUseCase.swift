import Foundation
import SharedKernel

public final class GetDailyVerseUseCase: Sendable {
    private let repository: DevotionalRepositoryProtocol
    
    public init(repository: DevotionalRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> VerseDTO {
        let dailyVerse = try await repository.getDailyVerse()
        return VerseDTO(
            id: dailyVerse.verse.id,
            Reference: dailyVerse.verse.reference,
            text: dailyVerse.verse.text,
            version: dailyVerse.verse.version,
            reflection: dailyVerse.reflection
        )
    }
}

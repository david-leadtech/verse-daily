import Foundation
import SharedKernel

public final class GetDevotionalsUseCase: Sendable {
    private let repository: DevotionalRepositoryProtocol
    
    public init(repository: DevotionalRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(limit: Int = 10) async throws -> [DevotionalDTO] {
        let devotionals = try await repository.getDevotionals(limit: limit)
        return devotionals.map {
            DevotionalDTO(
                id: $0.id,
                title: $0.title,
                category: $0.category,
                readTime: $0.readTime,
                verseReference: $0.verseReference
            )
        }
    }
}

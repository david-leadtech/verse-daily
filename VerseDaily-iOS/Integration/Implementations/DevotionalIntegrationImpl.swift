import Foundation

public final class DevotionalIntegrationImpl: DevotionalIntegration {
    private let repository: DevotionalRepositoryProtocol
    
    public init(repository: DevotionalRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getTodayVerseReference() async throws -> String {
        let daily = try await repository.getDailyVerse()
        return daily.verse.reference
    }
}

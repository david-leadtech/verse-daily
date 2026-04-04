import Foundation
import SharedKernel

public final class UserIntegrationImpl: UserIntegration {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func isPremium() async -> Bool {
        do {
            let settings = try await repository.getSettings()
            return settings.isPremium
        } catch {
            return false
        }
    }
    
    public func getPreferredBibleVersion() async -> String {
        do {
            let settings = try await repository.getSettings()
            return settings.bibleVersion
        } catch {
            return "KJV"
        }
    }
}

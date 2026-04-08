import Foundation

public final class MonetizationIntegrationImpl: MonetizationIntegration {
    private let repository: MonetizationRepositoryProtocol
    
    public init(repository: MonetizationRepositoryProtocol) {
        self.repository = repository
    }
    
    public func isPremiumUser() async -> Bool {
        do {
            let status = try await repository.getSubscriptionStatus()
            return status == .premium
        } catch {
            return false
        }
    }
}

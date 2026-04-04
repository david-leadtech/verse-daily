import Foundation
import SharedKernel

public protocol MonetizationRepositoryProtocol: Sendable {
    func getSubscriptionPlans() async throws -> [SubscriptionPlan]
    func getSubscriptionStatus() async throws -> SubscriptionStatus
    func purchase(planId: String) async throws -> Bool
    func restorePurchases() async throws -> Bool
}

import Foundation

public final class MockMonetizationRepository: MonetizationRepositoryProtocol {
    public init() {}
    
    public func getSubscriptionPlans() async throws -> [SubscriptionPlan] {
        return [
            SubscriptionPlan(id: "weekly", name: "Weekly", price: Money(amount: 9.99, currency: "USD"), period: "/week"),
            SubscriptionPlan(id: "yearly", name: "Annual", price: Money(amount: 69.99, currency: "USD"), period: "/year", savings: "Save 87%", isPopular: true)
        ]
    }
    
    public func getSubscriptionStatus() async throws -> SubscriptionStatus {
        return .free
    }
    
    public func purchase(planId: String) async throws -> Bool {
        return true
    }
    
    public func restorePurchases() async throws -> Bool {
        return true
    }
}

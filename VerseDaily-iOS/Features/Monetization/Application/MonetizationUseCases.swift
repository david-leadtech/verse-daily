import Foundation

// MARK: - SubscriptionPlanDTO (DTO for UI)
public struct SubscriptionPlanDTO: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let priceLabel: String
    public let period: String
    public let savings: String?
    public let isPopular: Bool

    public init(id: String, name: String, priceLabel: String, period: String, savings: String?, isPopular: Bool) {
        self.id = id
        self.name = name
        self.priceLabel = priceLabel
        self.period = period
        self.savings = savings
        self.isPopular = isPopular
    }
}

// MARK: - Get Subscription Plans Use Case
public final class GetSubscriptionPlansUseCase: Sendable {
    private let repository: MonetizationRepositoryProtocol

    public init(repository: MonetizationRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [SubscriptionPlanDTO] {
        let plans = try await repository.getSubscriptionPlans()
        return plans.map {
            SubscriptionPlanDTO(
                id: $0.id,
                name: $0.name,
                priceLabel: "\($0.price.amount) \($0.price.currency)",
                period: $0.period,
                savings: $0.savings,
                isPopular: $0.isPopular
            )
        }
    }
}

// MARK: - Subscribe Use Case
public final class SubscribeUseCase: Sendable {
    private let repository: MonetizationRepositoryProtocol

    public init(repository: MonetizationRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(planId: String) async throws -> Bool {
        try await repository.purchase(planId: planId)
    }
}

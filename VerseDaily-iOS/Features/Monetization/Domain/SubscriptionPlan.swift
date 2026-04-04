import Foundation
import SharedKernel

public struct SubscriptionPlan: Identifiable, Codable, Sendable, Equatable {
    public let id: String
    public let name: String
    public let price: Money
    public let period: String
    public let savings: String?
    public let isPopular: Bool
    
    public init(id: String, name: String, price: Money, period: String, savings: String? = nil, isPopular: Bool = false) {
        self.id = id
        self.name = name
        self.price = price
        self.period = period
        self.savings = savings
        self.isPopular = isPopular
    }
}

public enum SubscriptionStatus: Sendable, Equatable {
    case free
    case premium
    case expired
}

import Foundation

public struct Money: Codable, Sendable, Equatable {
    public let amount: Decimal
    public let currency: String
    
    public init(amount: Decimal, currency: String = "USD") {
        self.amount = amount
        self.currency = currency
    }
    
    public static var zero: Money {
        Money(amount: 0)
    }
    
    public func add(_ other: Money) throws -> Money {
        guard currency == other.currency else {
            throw DomainError.operationFailed("Currency mismatch: \(currency) vs \(other.currency)")
        }
        return Money(amount: amount + other.amount, currency: currency)
    }
}

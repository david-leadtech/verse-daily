import Foundation

public protocol MonetizationIntegration: Sendable {
    func isPremiumUser() async -> Bool
}

import Foundation
import SharedKernel

public protocol MonetizationIntegration: Sendable {
    func isPremiumUser() async -> Bool
}

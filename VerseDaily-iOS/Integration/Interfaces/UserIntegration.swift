import Foundation
import SharedKernel

public protocol UserIntegration: Sendable {
    func isPremium() async -> Bool
    func getPreferredBibleVersion() async -> String
}

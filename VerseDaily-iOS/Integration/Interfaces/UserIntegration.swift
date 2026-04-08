import Foundation

public protocol UserIntegration: Sendable {
    func isPremium() async -> Bool
    func getPreferredBibleVersion() async -> String
}

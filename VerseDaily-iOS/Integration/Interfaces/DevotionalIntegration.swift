import Foundation

public protocol DevotionalIntegration: Sendable {
    func getTodayVerseReference() async throws -> String
}

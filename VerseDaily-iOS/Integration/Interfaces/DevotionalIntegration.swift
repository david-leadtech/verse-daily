import Foundation
import SharedKernel

public protocol DevotionalIntegration: Sendable {
    func getTodayVerseReference() async throws -> String
}

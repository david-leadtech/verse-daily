import Foundation

public protocol DevotionalRepositoryProtocol: Sendable {
    func getDailyVerse() async throws -> DailyVerse
    func getDevotionals(limit: Int) async throws -> [Devotional]
    func getDevotional(id: Int) async throws -> Devotional
    func searchDevotionals(query: String) async throws -> [Devotional]
}

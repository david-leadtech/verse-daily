import Foundation

public protocol UserRepositoryProtocol: Sendable {
    func getSettings() async throws -> UserSettings
    func updateSettings(_ settings: UserSettings) async throws
    func resetSettings() async throws
}

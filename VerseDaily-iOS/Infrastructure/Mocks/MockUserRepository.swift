import Foundation

/// Mock implementation of UserRepositoryProtocol for testing/development
/// Axiom: In-memory deterministic data, no real persistence
public final class MockUserRepository: UserRepositoryProtocol {
    private var settings = UserSettings()

    public init() {}

    public func getSettings() async throws -> UserSettings {
        return settings
    }

    public func updateSettings(_ settings: UserSettings) async throws {
        self.settings = settings
    }

    public func resetSettings() async throws {
        self.settings = UserSettings()
    }
}

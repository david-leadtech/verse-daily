import Foundation
import SharedKernel

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

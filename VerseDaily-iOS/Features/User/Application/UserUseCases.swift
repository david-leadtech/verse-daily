import Foundation
import SharedKernel

public struct UserSettingsDTO: Sendable {
    public let notificationsEnabled: Bool
    public let notificationTime: String
    public let bibleVersion: String
    public let isPremium: Bool
    
    public init(notificationsEnabled: Bool, notificationTime: String, bibleVersion: String, isPremium: Bool) {
        self.notificationsEnabled = notificationsEnabled
        self.notificationTime = notificationTime
        self.bibleVersion = bibleVersion
        self.isPremium = isPremium
    }
}

public final class GetUserSettingsUseCase: Sendable {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> UserSettingsDTO {
        let settings = try await repository.getSettings()
        return UserSettingsDTO(
            notificationsEnabled: settings.notificationsEnabled,
            notificationTime: settings.notificationTime,
            bibleVersion: settings.bibleVersion,
            isPremium: settings.isPremium
        )
    }
}

public final class UpdateUserSettingsUseCase: Sendable {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(notificationsEnabled: Bool? = nil, 
                        notificationTime: String? = nil, 
                        bibleVersion: String? = nil, 
                        isPremium: Bool? = nil) async throws {
        var current = try await repository.getSettings()
        if let notificationsEnabled = notificationsEnabled { current.notificationsEnabled = notificationsEnabled }
        if let notificationTime = notificationTime { current.notificationTime = notificationTime }
        if let bibleVersion = bibleVersion { current.bibleVersion = bibleVersion }
        if let isPremium = isPremium { current.isPremium = isPremium }
        try await repository.updateSettings(current)
    }
}

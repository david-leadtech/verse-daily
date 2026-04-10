import Foundation

// MARK: - Domain imports
// Note: Domain types (UserSettings, UserRepositoryProtocol, OnboardingError) should be auto-linked from project target

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

// MARK: - Onboarding Use Cases

/// Protocol for completing onboarding and saving user settings
/// Axiom: One use case = one operation, dependencies injected
public protocol CompleteOnboardingUseCaseProtocol: Sendable {
    func execute(with settings: UserSettings) async throws
}

/// Implementation of CompleteOnboardingUseCase
/// Orchestrates: validate → save → return result
public final class CompleteOnboardingUseCase: CompleteOnboardingUseCaseProtocol, Sendable {
    private let userRepository: UserRepositoryProtocol

    // MARK: - Init
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    // MARK: - Public Methods
    /// Saves completed onboarding settings to repository
    /// - Parameter settings: Validated UserSettings with onboarding data
    /// - Throws: OnboardingError if persistence fails
    public func execute(with settings: UserSettings) async throws {
        do {
            try await userRepository.updateSettings(settings)
        } catch {
            // Map repository errors to domain errors
            throw mapError(error)
        }
    }

    // MARK: - Private Methods
    /// Maps repository/persistence errors
    private func mapError(_ error: Error) -> Error {
        // Return the error as-is; repository handles error mapping
        return error
    }
}

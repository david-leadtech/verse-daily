import Foundation
import SwiftData
import CoreModels

/// Real implementation of UserRepositoryProtocol using SwiftData
/// Axiom: Repository orchestrates domain logic, persistence, error handling
@MainActor
public final class UserRepository: UserRepositoryProtocol {
    private var modelContainer: ModelContainer?

    // MARK: - Init
    public init() {
        setupModelContainer()
    }

    // MARK: - Public Methods
    /// Fetches user settings from SwiftData, or returns defaults if not found
    public func getSettings() async throws -> UserSettings {
        guard let container = modelContainer else {
            throw OnboardingError.persistenceFailed("Model container not initialized")
        }

        let descriptor = FetchDescriptor<UserProfile>()
        let context = ModelContext(container)
        let profiles = try context.fetch(descriptor)

        if let profile = profiles.first {
            return UserSettings(from: profile)
        }

        // Return default settings if no profile exists yet
        return UserSettings()
    }

    /// Saves or updates user settings in SwiftData
    public func updateSettings(_ settings: UserSettings) async throws {
        guard let container = modelContainer else {
            throw OnboardingError.persistenceFailed("Model container not initialized")
        }

        let context = ModelContext(container)
        let descriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(descriptor)

        let profile: UserProfile
        if let existing = profiles.first {
            // Update existing profile
            profile = existing
        } else {
            // Create new profile
            profile = UserProfile()
            context.insert(profile)
        }

        // Update profile from settings
        profile.update(from: settings)
        profile.updatedAt = Date()

        // Save changes
        try context.save()
    }

    /// Resets user settings to defaults
    public func resetSettings() async throws {
        guard let container = modelContainer else {
            throw OnboardingError.persistenceFailed("Model container not initialized")
        }

        let context = ModelContext(container)
        let descriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(descriptor)

        for profile in profiles {
            context.delete(profile)
        }

        try context.save()
    }

    // MARK: - Private Methods
    private func setupModelContainer() {
        do {
            let schema = Schema([UserProfile.self])
            let config = ModelConfiguration("VerseDailyUserProfile", schema: schema)
            self.modelContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            print("Failed to setup UserRepository ModelContainer: \(error)")
        }
    }
}

// MARK: - UserSettings/UserProfile Conversion
extension UserSettings {
    /// Initialize from a UserProfile SwiftData model
    init(from profile: UserProfile) {
        self.userName = profile.userName
        self.userEmail = profile.userEmail
        self.ageRange = profile.ageRange.flatMap { AgeRange(rawValue: $0) }
        self.gender = profile.gender.flatMap { Gender(rawValue: $0) }
        self.church = profile.church
        self.bibleVersion = profile.bibleVersion ?? "RVR1960"
        self.readingPreferences = (profile.readingPreferences ?? []).compactMap { ReadingPreference(rawValue: $0) }
        self.appTheme = AppTheme(rawValue: profile.appTheme) ?? .system
        self.textSize = TextSize(rawValue: profile.textSize) ?? .normal
        self.appLanguage = AppLanguage(rawValue: profile.appLanguage) ?? .spanish
        self.notificationsEnabled = true
        self.notificationTime = "08:00"
        self.readingGoal = profile.readingGoal.flatMap { ReadingGoal(rawValue: $0) }
        self.isPremium = false
    }
}

extension UserProfile {
    /// Update profile from UserSettings
    func update(from settings: UserSettings) {
        self.userName = settings.userName
        self.userEmail = settings.userEmail
        self.ageRange = settings.ageRange?.rawValue
        self.gender = settings.gender?.rawValue
        self.church = settings.church
        self.readingPreferences = settings.readingPreferences?.map { $0.rawValue }
        self.appTheme = settings.appTheme.rawValue
        self.textSize = settings.textSize.rawValue
        self.appLanguage = settings.appLanguage.rawValue
        self.readingGoal = settings.readingGoal?.rawValue
        self.hasCompletedOnboarding = true
    }
}

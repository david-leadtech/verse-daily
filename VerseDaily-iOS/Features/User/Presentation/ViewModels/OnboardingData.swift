import Foundation

/// Presentation DTO for onboarding data
/// Axiom: Sendable, Hashable, Equatable, uses enums (not strings)
public struct OnboardingData: Sendable, Hashable, Equatable {
    // MARK: - Profile Data
    public var userName: String = ""
    public var userEmail: String = ""
    public var ageRange: AgeRange?
    public var gender: Gender?

    // MARK: - Religious Preferences
    public var church: String = ""
    public var bibleVersion: String = "KJV"
    public var readingPreferences: Set<ReadingPreference> = []

    // MARK: - Theme & Language
    public var appTheme: AppTheme = .system
    public var textSize: TextSize = .normal
    public var appLanguage: AppLanguage = .spanish

    // MARK: - Notifications & Engagement
    public var notificationsEnabled: Bool = true
    public var notificationTime: String = "08:00"
    public var readingGoal: ReadingGoal?

    public init() {}

    // MARK: - Conversion to Domain
    /// Converts presentation DTO to domain UserSettings
    public func toUserSettings() -> UserSettings {
        UserSettings(
            notificationsEnabled: notificationsEnabled,
            notificationTime: notificationTime,
            bibleVersion: bibleVersion,
            isPremium: false,
            hasCompletedOnboarding: true,
            userName: userName.isEmpty ? nil : userName,
            userEmail: userEmail.isEmpty ? nil : userEmail,
            ageRange: ageRange,
            gender: gender,
            church: church.isEmpty ? nil : church,
            readingPreferences: readingPreferences.isEmpty ? nil : Array(readingPreferences),
            appTheme: appTheme,
            textSize: textSize,
            appLanguage: appLanguage,
            readingGoal: readingGoal
        )
    }

    // MARK: - Validation
    /// Validates profile info step
    public func validateProfileInfo() -> ValidationResult {
        var errors: [String] = []

        if userName.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(LocalizationKey.validationErrorNameRequired.localized)
        }

        if userEmail.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append(LocalizationKey.validationErrorInvalidEmail.localized)
        } else if !isValidEmail(userEmail) {
            errors.append(LocalizationKey.validationErrorInvalidEmail.localized)
        }

        if ageRange == nil {
            errors.append(LocalizationKey.validationErrorAgeRangeRequired.localized)
        }

        if gender == nil {
            errors.append(LocalizationKey.validationErrorGenderRequired.localized)
        }

        return errors.isEmpty ? .success : .failure(errors)
    }

    /// Validates religious preferences step
    public func validateReligiousPreferences() -> ValidationResult {
        var errors: [String] = []

        if readingPreferences.isEmpty {
            errors.append(LocalizationKey.validationErrorReadingPreferencesRequired.localized)
        }

        return errors.isEmpty ? .success : .failure(errors)
    }

    // MARK: - Private Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailPattern).evaluate(with: email)
    }
}

// MARK: - Validation Result
public enum ValidationResult: Sendable, Equatable {
    case success
    case failure([String])

    public var isValid: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    public var errors: [String] {
        if case .failure(let errors) = self {
            return errors
        }
        return []
    }
}

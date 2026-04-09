import Foundation

/// Represents a step in the onboarding flow
/// Axiom: Use enums for state instead of strings
public enum OnboardingStep: Identifiable, Sendable, Hashable, Equatable {
    case profileInfo
    case religiousPreferences
    case themeLanguage
    case notificationsGoal
    case summary

    public var id: Self { self }

    public var title: String {
        switch self {
        case .profileInfo:
            return LocalizationKey.onboardingProfileInfoTitle.localized
        case .religiousPreferences:
            return LocalizationKey.onboardingReligiousPreferencesTitle.localized
        case .themeLanguage:
            return LocalizationKey.onboardingThemeLanguageTitle.localized
        case .notificationsGoal:
            return LocalizationKey.onboardingNotificationsGoalTitle.localized
        case .summary:
            return LocalizationKey.onboardingSummaryTitle.localized
        }
    }

    public var stepNumber: Int {
        switch self {
        case .profileInfo:
            return 1
        case .religiousPreferences:
            return 2
        case .themeLanguage:
            return 3
        case .notificationsGoal:
            return 4
        case .summary:
            return 5
        }
    }

    public var totalSteps: Int { 5 }

    public var progress: Double {
        Double(stepNumber) / Double(totalSteps)
    }

    public mutating func nextStep() -> Bool {
        switch self {
        case .profileInfo:
            self = .religiousPreferences
            return true
        case .religiousPreferences:
            self = .themeLanguage
            return true
        case .themeLanguage:
            self = .notificationsGoal
            return true
        case .notificationsGoal:
            self = .summary
            return true
        case .summary:
            return false
        }
    }

    public mutating func previousStep() -> Bool {
        switch self {
        case .profileInfo:
            return false
        case .religiousPreferences:
            self = .profileInfo
            return true
        case .themeLanguage:
            self = .religiousPreferences
            return true
        case .notificationsGoal:
            self = .themeLanguage
            return true
        case .summary:
            self = .notificationsGoal
            return true
        }
    }
}

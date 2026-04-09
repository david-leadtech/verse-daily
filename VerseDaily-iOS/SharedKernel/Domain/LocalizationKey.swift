import Foundation

/// Centralized localization keys - no hardcoded strings
/// Extensible to all UI text
public enum LocalizationKey: String, Sendable {
    // MARK: - Onboarding Steps
    case onboardingProfileInfoTitle = "onboarding.step.profileInfo.title"
    case onboardingReligiousPreferencesTitle = "onboarding.step.religiousPreferences.title"
    case onboardingThemeLanguageTitle = "onboarding.step.themeLanguage.title"
    case onboardingNotificationsGoalTitle = "onboarding.step.notificationsGoal.title"
    case onboardingSummaryTitle = "onboarding.step.summary.title"

    // MARK: - Enum: Age Range
    case enumAgeRangeTeen = "enum.ageRange.teen"
    case enumAgeRangeYoungAdult = "enum.ageRange.youngAdult"
    case enumAgeRangeAdult = "enum.ageRange.adult"
    case enumAgeRangeMiddleAge = "enum.ageRange.middleAge"
    case enumAgeRangeMature = "enum.ageRange.mature"
    case enumAgeRangeSenior = "enum.ageRange.senior"

    // MARK: - Enum: Gender
    case enumGenderMale = "enum.gender.male"
    case enumGenderFemale = "enum.gender.female"
    case enumGenderOther = "enum.gender.other"
    case enumGenderPreferNotToSay = "enum.gender.preferNotToSay"

    // MARK: - Enum: Theme
    case enumThemeLight = "enum.theme.light"
    case enumThemeDark = "enum.theme.dark"
    case enumThemeSystem = "enum.theme.system"

    // MARK: - Enum: Text Size
    case enumTextSizeSmall = "enum.textSize.small"
    case enumTextSizeNormal = "enum.textSize.normal"
    case enumTextSizeLarge = "enum.textSize.large"

    // MARK: - Enum: Language
    case enumLanguageSpanish = "enum.language.spanish"
    case enumLanguageEnglish = "enum.language.english"
    case enumLanguagePortuguese = "enum.language.portuguese"

    // MARK: - Enum: Reading Goal
    case enumReadingGoalCasual = "enum.readingGoal.casual"
    case enumReadingGoalRegular = "enum.readingGoal.regular"
    case enumReadingGoalDedicated = "enum.readingGoal.dedicated"
    case enumReadingGoalIntensive = "enum.readingGoal.intensive"
    case enumReadingGoalCasualDesc = "enum.readingGoal.casual.description"
    case enumReadingGoalRegularDesc = "enum.readingGoal.regular.description"
    case enumReadingGoalDedicatedDesc = "enum.readingGoal.dedicated.description"
    case enumReadingGoalIntensiveDesc = "enum.readingGoal.intensive.description"

    // MARK: - Enum: Reading Preference
    case enumReadingPreferenceContinuous = "enum.readingPreference.continuous"
    case enumReadingPreferenceThematic = "enum.readingPreference.thematic"
    case enumReadingPreferencePsalms = "enum.readingPreference.psalms"
    case enumReadingPreferenceGospels = "enum.readingPreference.gospels"
    case enumReadingPreferenceEpistles = "enum.readingPreference.epistles"

    // MARK: - Validation Errors
    case validationErrorNameRequired = "validation.error.nameRequired"
    case validationErrorInvalidEmail = "validation.error.invalidEmail"
    case validationErrorAgeRangeRequired = "validation.error.ageRangeRequired"
    case validationErrorGenderRequired = "validation.error.genderRequired"
    case validationErrorReadingPreferencesRequired = "validation.error.readingPreferencesRequired"

    // MARK: - Onboarding Errors
    case onboardingErrorPersistenceFailed = "onboarding.error.persistenceFailed"
    case onboardingErrorUnknown = "onboarding.error.unknown"

    /// Localized string value
    public var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }

    /// Localized string with format arguments
    public func localized(with args: CVarArg...) -> String {
        String(format: NSLocalizedString(self.rawValue, comment: ""), arguments: args)
    }
}

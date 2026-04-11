import Foundation

// MARK: - Localization Keys (Dynamic, no hardcoded strings)
public enum LocalizationKey: String, Sendable, Hashable, CaseIterable {
    case enumThemeLight = "enum.theme.light"
    case enumThemeDark = "enum.theme.dark"
    case enumThemeSystem = "enum.theme.system"
    case enumTextSizeSmall = "enum.textSize.small"
    case enumTextSizeNormal = "enum.textSize.normal"
    case enumTextSizeLarge = "enum.textSize.large"
    case enumLanguageSpanish = "enum.language.spanish"
    case enumLanguageEnglish = "enum.language.english"
    case enumLanguagePortuguese = "enum.language.portuguese"
    case enumGenderMale = "enum.gender.male"
    case enumGenderFemale = "enum.gender.female"
    case enumGenderOther = "enum.gender.other"
    case enumGenderPreferNotToSay = "enum.gender.preferNotToSay"
    case enumReadingGoalCasual = "enum.readingGoal.casual"
    case enumReadingGoalRegular = "enum.readingGoal.regular"
    case enumReadingGoalDedicated = "enum.readingGoal.dedicated"
    case enumReadingGoalIntensive = "enum.readingGoal.intensive"
    case enumReadingGoalCasualDesc = "enum.readingGoal.casual.description"
    case enumReadingGoalRegularDesc = "enum.readingGoal.regular.description"
    case enumReadingGoalDedicatedDesc = "enum.readingGoal.dedicated.description"
    case enumReadingGoalIntensiveDesc = "enum.readingGoal.intensive.description"
    case enumReadingPreferenceContinuous = "enum.readingPreference.continuous"
    case enumReadingPreferenceThematic = "enum.readingPreference.thematic"
    case enumReadingPreferencePsalms = "enum.readingPreference.psalms"
    case enumReadingPreferenceGospels = "enum.readingPreference.gospels"
    case enumReadingPreferenceEpistles = "enum.readingPreference.epistles"
    case enumCanonProtestant = "enum.canon.protestant"
    case enumCanonCatholic = "enum.canon.catholic"
    case enumCanonOrthodox = "enum.canon.orthodox"
    case validationErrorNameRequired = "validation.error.nameRequired"
    case validationErrorInvalidEmail = "validation.error.invalidEmail"
    case validationErrorAgeRangeRequired = "validation.error.ageRangeRequired"
    case validationErrorGenderRequired = "validation.error.genderRequired"
    case validationErrorReadingPreferencesRequired = "validation.error.readingPreferencesRequired"
    case onboardingErrorPersistenceFailed = "onboarding.error.persistenceFailed"
    case onboardingErrorUnknown = "onboarding.error.unknown"

    // Onboarding Step Titles (used by OnboardingStep.swift)
    case onboardingProfileInfoTitle = "onboarding.profileInfo.title"
    case onboardingReligiousPreferencesTitle = "onboarding.religiousPreferences.title"
    case onboardingThemeLanguageTitle = "onboarding.themeLanguage.title"
    case onboardingNotificationsGoalTitle = "onboarding.notificationsGoal.title"
    case onboardingSummaryTitle = "onboarding.summary.title"

    // Onboarding UI Field Labels
    case onboardingProfileInfoNameLabel = "onboarding.profileInfo.nameLabel"
    case onboardingProfileInfoEmailLabel = "onboarding.profileInfo.emailLabel"
    case onboardingProfileInfoAgeRangeLabel = "onboarding.profileInfo.ageRangeLabel"
    case onboardingProfileInfoGenderLabel = "onboarding.profileInfo.genderLabel"

    case onboardingReligiousPreferencesChurchLabel = "onboarding.religiousPreferences.churchLabel"
    case onboardingReligiousPreferencesBibleVersionLabel = "onboarding.religiousPreferences.bibleVersionLabel"
    case onboardingReligiousPreferencesReadingPreferencesLabel = "onboarding.religiousPreferences.readingPreferencesLabel"

    case onboardingThemeLanguageThemeTitle = "onboarding.themeLanguage.themeTitle"
    case onboardingThemeLanguageThemeLabel = "onboarding.themeLanguage.themeLabel"
    case onboardingThemeLanguageTextSizeTitle = "onboarding.themeLanguage.textSizeTitle"
    case onboardingThemeLanguageTextSizeLabel = "onboarding.themeLanguage.textSizeLabel"
    case onboardingThemeLanguageLanguageTitle = "onboarding.themeLanguage.languageTitle"
    case onboardingThemeLanguageLanguageLabel = "onboarding.themeLanguage.languageLabel"

    case onboardingNotificationsToggleLabel = "onboarding.notifications.toggleLabel"
    case onboardingNotificationsTimeLabel = "onboarding.notifications.timeLabel"
    case onboardingNotificationsTimePickerLabel = "onboarding.notifications.timePickerLabel"
    case onboardingNotificationsReadingGoalLabel = "onboarding.notifications.readingGoalLabel"
    case onboardingNotificationsReadingGoalNone = "onboarding.notifications.readingGoalNone"
    case onboardingNotificationsEnabledValue = "onboarding.notifications.enabledValue"
    case onboardingNotificationsDisabledValue = "onboarding.notifications.disabledValue"

    // Onboarding Button Labels
    case onboardingCompleteButtonLabel = "onboarding.button.complete"
    case onboardingSkipButtonLabel = "onboarding.button.skip"
    case onboardingNextButtonLabel = "onboarding.button.next"
    case onboardingBackButtonLabel = "onboarding.button.back"

    // Onboarding Generic Labels
    case onboardingSelectPlaceholder = "onboarding.placeholder.select"
    case onboardingOptionalLabel = "onboarding.label.optional"

    // Home View
    case homeGreetingGoodMorning = "home.greeting.goodMorning"
    case homeVerseOfTheDay = "home.verse.ofTheDay"
    case homeTodaysDevotionals = "home.devotionals.today"
    case homePremiumFeature = "home.premium.feature"
    case homeUnlockDevotionals = "home.premium.unlock"
    case homeDevotionalsDesc = "home.premium.description"
    case homeUpgradePremium = "home.premium.upgrade"

    public var localized: String {
        NSLocalizedString(self.rawValue, comment: "")
    }

    public func localized(with args: CVarArg...) -> String {
        String(format: NSLocalizedString(self.rawValue, comment: ""), arguments: args)
    }
}

// MARK: - Age Range (Localizable strings, no hardcoded text)
public enum AgeRange: String, Codable, Sendable, Hashable, CaseIterable {
    case teen = "13-17"
    case youngAdult = "18-25"
    case adult = "26-35"
    case middleAge = "36-50"
    case mature = "51-65"
    case senior = "66+"

    public var displayName: String {
        self.rawValue
    }
}

// MARK: - Gender
public enum Gender: String, Codable, Sendable, Hashable, CaseIterable {
    case male = "masculino"
    case female = "femenino"
    case other = "otro"
    case preferNotToSay = "prefiero_no_decir"

    public var displayName: String {
        switch self {
        case .male:
            return LocalizationKey.enumGenderMale.localized
        case .female:
            return LocalizationKey.enumGenderFemale.localized
        case .other:
            return LocalizationKey.enumGenderOther.localized
        case .preferNotToSay:
            return LocalizationKey.enumGenderPreferNotToSay.localized
        }
    }
}

// MARK: - App Theme
public enum AppTheme: String, Codable, Sendable, Hashable, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"

    public var displayName: String {
        switch self {
        case .light:
            return LocalizationKey.enumThemeLight.localized
        case .dark:
            return LocalizationKey.enumThemeDark.localized
        case .system:
            return LocalizationKey.enumThemeSystem.localized
        }
    }
}

// MARK: - Text Size
public enum TextSize: String, Codable, Sendable, Hashable, CaseIterable {
    case small = "small"
    case normal = "normal"
    case large = "large"

    public var displayName: String {
        switch self {
        case .small:
            return LocalizationKey.enumTextSizeSmall.localized
        case .normal:
            return LocalizationKey.enumTextSizeNormal.localized
        case .large:
            return LocalizationKey.enumTextSizeLarge.localized
        }
    }
}

// MARK: - App Language
public enum AppLanguage: String, Codable, Sendable, Hashable, CaseIterable {
    case spanish = "es"
    case english = "en"
    case portuguese = "pt"

    public var displayName: String {
        switch self {
        case .spanish:
            return LocalizationKey.enumLanguageSpanish.localized
        case .english:
            return LocalizationKey.enumLanguageEnglish.localized
        case .portuguese:
            return LocalizationKey.enumLanguagePortuguese.localized
        }
    }
}

// MARK: - Reading Goal
public enum ReadingGoal: String, Codable, Sendable, Hashable, CaseIterable {
    case casual = "casual"
    case regular = "regular"
    case dedicated = "dedicado"
    case intensive = "intensivo"

    public var displayName: String {
        switch self {
        case .casual:
            return LocalizationKey.enumReadingGoalCasual.localized
        case .regular:
            return LocalizationKey.enumReadingGoalRegular.localized
        case .dedicated:
            return LocalizationKey.enumReadingGoalDedicated.localized
        case .intensive:
            return LocalizationKey.enumReadingGoalIntensive.localized
        }
    }

    public var description: String {
        switch self {
        case .casual:
            return LocalizationKey.enumReadingGoalCasualDesc.localized
        case .regular:
            return LocalizationKey.enumReadingGoalRegularDesc.localized
        case .dedicated:
            return LocalizationKey.enumReadingGoalDedicatedDesc.localized
        case .intensive:
            return LocalizationKey.enumReadingGoalIntensiveDesc.localized
        }
    }
}

// MARK: - Reading Preferences
public enum ReadingPreference: String, Codable, Sendable, Hashable, CaseIterable {
    case continuous = "lectura_continua"
    case thematic = "tematica"
    case psalms = "salmos"
    case gospels = "evangelios"
    case epistles = "epistolas"

    public var displayName: String {
        switch self {
        case .continuous:
            return LocalizationKey.enumReadingPreferenceContinuous.localized
        case .thematic:
            return LocalizationKey.enumReadingPreferenceThematic.localized
        case .psalms:
            return LocalizationKey.enumReadingPreferencePsalms.localized
        case .gospels:
            return LocalizationKey.enumReadingPreferenceGospels.localized
        case .epistles:
            return LocalizationKey.enumReadingPreferenceEpistles.localized
        }
    }
}

// MARK: - Biblical Canon
public enum Canon: String, Codable, Sendable, Hashable, CaseIterable {
    case protestant = "protestant"
    case catholic = "catholic"
    case orthodox = "orthodox"

    public var displayName: String {
        switch self {
        case .protestant:
            return LocalizationKey.enumCanonProtestant.localized
        case .catholic:
            return LocalizationKey.enumCanonCatholic.localized
        case .orthodox:
            return LocalizationKey.enumCanonOrthodox.localized
        }
    }
}

// MARK: - User Settings
public struct UserSettings: Codable, Sendable, Equatable {
    // MARK: - Existing Settings
    public var notificationsEnabled: Bool
    public var notificationTime: String
    public var bibleVersion: String
    public var isPremium: Bool

    // MARK: - Onboarding & Profile Data
    public var hasCompletedOnboarding: Bool
    public var userName: String?
    public var userEmail: String?
    public var ageRange: AgeRange?
    public var gender: Gender?

    // MARK: - Religious Preferences
    public var church: String?
    public var canon: Canon
    public var showAdditionalBooks: Bool
    public var readingPreferences: [ReadingPreference]?

    // MARK: - Theme & Language (Axiom: Use enums, not strings)
    public var appTheme: AppTheme
    public var textSize: TextSize
    public var appLanguage: AppLanguage

    // MARK: - Engagement
    public var readingGoal: ReadingGoal?

    public init(
        notificationsEnabled: Bool = true,
        notificationTime: String = "08:00",
        bibleVersion: String = "KJV",
        isPremium: Bool = false,
        hasCompletedOnboarding: Bool = false,
        userName: String? = nil,
        userEmail: String? = nil,
        ageRange: AgeRange? = nil,
        gender: Gender? = nil,
        church: String? = nil,
        canon: Canon = .protestant,
        showAdditionalBooks: Bool = false,
        readingPreferences: [ReadingPreference]? = nil,
        appTheme: AppTheme = .system,
        textSize: TextSize = .normal,
        appLanguage: AppLanguage = .spanish,
        readingGoal: ReadingGoal? = nil
    ) {
        self.notificationsEnabled = notificationsEnabled
        self.notificationTime = notificationTime
        self.bibleVersion = bibleVersion
        self.isPremium = isPremium
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.userName = userName
        self.userEmail = userEmail
        self.ageRange = ageRange
        self.gender = gender
        self.church = church
        self.canon = canon
        self.showAdditionalBooks = showAdditionalBooks
        self.readingPreferences = readingPreferences
        self.appTheme = appTheme
        self.textSize = textSize
        self.appLanguage = appLanguage
        self.readingGoal = readingGoal
    }
}

// (These lines are appended but actually need to be inserted before "public var localized")

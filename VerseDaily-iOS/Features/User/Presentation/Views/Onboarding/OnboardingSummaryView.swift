import SwiftUI

struct OnboardingSummaryView: View {
    let userData: OnboardingData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Profile Section
                SummarySection(
                    title: LocalizationKey.onboardingProfileInfoTitle.localized,
                    content: [
                        (LocalizationKey.onboardingProfileInfoNameLabel.localized, userData.userName ?? "-"),
                        (LocalizationKey.onboardingProfileInfoEmailLabel.localized, userData.userEmail ?? "-"),
                        (LocalizationKey.onboardingProfileInfoAgeRangeLabel.localized, userData.ageRange?.displayName ?? "-"),
                        (LocalizationKey.onboardingProfileInfoGenderLabel.localized, userData.gender?.displayName ?? "-")
                    ]
                )

                // MARK: - Religious Preferences Section
                SummarySection(
                    title: LocalizationKey.onboardingReligiousPreferencesTitle.localized,
                    content: [
                        (LocalizationKey.onboardingReligiousPreferencesChurchLabel.localized, userData.church ?? "-"),
                        (LocalizationKey.onboardingReligiousPreferencesBibleVersionLabel.localized, userData.bibleVersion),
                        (LocalizationKey.onboardingReligiousPreferencesReadingPreferencesLabel.localized,
                         userData.readingPreferences?.map { $0.displayName }.joined(separator: ", ") ?? "-")
                    ]
                )

                // MARK: - Theme & Language Section
                SummarySection(
                    title: LocalizationKey.onboardingThemeLanguageTitle.localized,
                    content: [
                        (LocalizationKey.onboardingThemeLanguageThemeLabel.localized, userData.appTheme.displayName),
                        (LocalizationKey.onboardingThemeLanguageTextSizeLabel.localized, userData.textSize.displayName),
                        (LocalizationKey.onboardingThemeLanguageLanguageLabel.localized, userData.appLanguage.displayName)
                    ]
                )

                // MARK: - Notifications Section
                SummarySection(
                    title: LocalizationKey.onboardingNotificationsTitle.localized,
                    content: [
                        (LocalizationKey.onboardingNotificationsToggleLabel.localized,
                         userData.notificationsEnabled ? LocalizationKey.onboardingNotificationsEnabledValue.localized : LocalizationKey.onboardingNotificationsDisabledValue.localized),
                        (LocalizationKey.onboardingNotificationsTimeLabel.localized, userData.notificationTime),
                        (LocalizationKey.onboardingNotificationsReadingGoalLabel.localized,
                         userData.readingGoal?.displayName ?? "-")
                    ]
                )

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Summary Section Component
struct SummarySection: View {
    let title: String
    let content: [(label: String, value: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(content, id: \.label) { item in
                    HStack(alignment: .top) {
                        Text(item.label)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: 100, alignment: .leading)

                        Spacer()

                        Text(item.value)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

#Preview {
    OnboardingSummaryView(
        userData: OnboardingData(
            userName: "Juan Pérez",
            userEmail: "juan@example.com",
            ageRange: .adult,
            gender: .male,
            church: "Iglesia Central",
            bibleVersion: "RVR1960",
            readingPreferences: [.continuous, .gospels],
            appTheme: .system,
            textSize: .normal,
            appLanguage: .spanish,
            notificationsEnabled: true,
            notificationTime: "08:00",
            readingGoal: .regular
        )
    )
}

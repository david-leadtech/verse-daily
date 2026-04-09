import SwiftUI

struct OnboardingThemeLanguageView: View {
    @Binding var userData: OnboardingData

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Theme Selection
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKey.onboardingThemeLanguageThemeTitle.localized)
                    .font(.headline)
                    .foregroundColor(.primary)

                Picker(LocalizationKey.onboardingThemeLanguageThemeLabel.localized, selection: $userData.appTheme) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
                .pickerStyle(.segmented)
            }

            // MARK: - Text Size Selection
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKey.onboardingThemeLanguageTextSizeTitle.localized)
                    .font(.headline)
                    .foregroundColor(.primary)

                Picker(LocalizationKey.onboardingThemeLanguageTextSizeLabel.localized, selection: $userData.textSize) {
                    ForEach(TextSize.allCases, id: \.self) { size in
                        Text(size.displayName).tag(size)
                    }
                }
                .pickerStyle(.segmented)
            }

            // MARK: - Language Selection
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKey.onboardingThemeLanguageLanguageTitle.localized)
                    .font(.headline)
                    .foregroundColor(.primary)

                Picker(LocalizationKey.onboardingThemeLanguageLanguageLabel.localized, selection: $userData.appLanguage) {
                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Text(language.displayName).tag(language)
                    }
                }
                .pickerStyle(.segmented)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

#Preview {
    OnboardingThemeLanguageView(
        userData: .constant(OnboardingData())
    )
}

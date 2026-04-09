import SwiftUI

struct OnboardingProfileView: View {
    @Binding var userData: OnboardingData

    var body: some View {
        VStack(spacing: 16) {
            // Name input
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizationKey.onboardingProfileInfoNameLabel.localized)
                    .font(.headline)
                TextField(LocalizationKey.onboardingProfileInfoNameLabel.localized, text: $userData.userName)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.words)
            }

            // Email input
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizationKey.onboardingProfileInfoEmailLabel.localized + " (\(LocalizationKey.onboardingOptionalLabel.localized))")
                    .font(.headline)
                TextField("tu@email.com", text: $userData.userEmail)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
            }

            // Age range picker
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizationKey.onboardingProfileInfoAgeRangeLabel.localized)
                    .font(.headline)
                Picker(LocalizationKey.onboardingProfileInfoAgeRangeLabel.localized, selection: $userData.ageRange) {
                    Text(LocalizationKey.onboardingSelectPlaceholder.localized).tag(Optional<AgeRange>(nil))
                    ForEach(AgeRange.allCases, id: \.self) { age in
                        Text(age.displayName).tag(Optional(age))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Gender picker
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizationKey.onboardingProfileInfoGenderLabel.localized)
                    .font(.headline)
                Picker(LocalizationKey.onboardingProfileInfoGenderLabel.localized, selection: $userData.gender) {
                    Text(LocalizationKey.onboardingSelectPlaceholder.localized).tag(Optional<Gender>(nil))
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.displayName).tag(Optional(gender))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

#Preview {
    @State var data = OnboardingData()
    return OnboardingProfileView(userData: $data)
}

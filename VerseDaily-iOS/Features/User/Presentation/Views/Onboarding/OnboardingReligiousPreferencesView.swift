import SwiftUI

struct OnboardingReligiousPreferencesView: View {
    @Binding var userData: OnboardingData

    var body: some View {
        VStack(spacing: 16) {
            // Biblical Tradition picker
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("📖 Biblical Tradition")
                        .font(.headline)
                    Spacer()
                    Text("(Auto-detected)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Picker("Biblical Tradition", selection: $userData.canon) {
                    ForEach(Canon.allCases, id: \.self) { canon in
                        Text(canon.displayName).tag(canon)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Bible version picker
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizationKey.onboardingReligiousPreferencesBibleVersionLabel.localized)
                    .font(.headline)
                Picker(LocalizationKey.onboardingReligiousPreferencesBibleVersionLabel.localized, selection: $userData.bibleVersion) {
                    ForEach(["KJV", "NKJV", "NIV", "ESV", "RVR1960"], id: \.self) { version in
                        Text(version).tag(version)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Reading preferences (multi-select)
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKey.onboardingReligiousPreferencesReadingPreferencesLabel.localized)
                    .font(.headline)

                ForEach(ReadingPreference.allCases, id: \.self) { preference in
                    Toggle(preference.displayName, isOn: .init(
                        get: { userData.readingPreferences.contains(preference) },
                        set: { isOn in
                            if isOn {
                                userData.readingPreferences.append(preference)
                            } else {
                                userData.readingPreferences.removeAll { $0 == preference }
                            }
                        }
                    ))
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
}

#Preview {
    @State var data = OnboardingData()
    return OnboardingReligiousPreferencesView(userData: $data)
}

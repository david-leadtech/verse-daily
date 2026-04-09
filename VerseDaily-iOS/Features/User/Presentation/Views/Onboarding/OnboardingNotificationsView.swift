import SwiftUI

struct OnboardingNotificationsView: View {
    @Binding var userData: OnboardingData

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Enable Notifications Toggle
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(LocalizationKey.onboardingNotificationsToggleLabel.localized)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Toggle("", isOn: $userData.notificationsEnabled)
                        .labelsHidden()
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(8)

            // MARK: - Notification Time (only if enabled)
            if userData.notificationsEnabled {
                VStack(alignment: .leading, spacing: 12) {
                    Text(LocalizationKey.onboardingNotificationsTimeLabel.localized)
                        .font(.headline)
                        .foregroundColor(.primary)

                    DatePicker(
                        LocalizationKey.onboardingNotificationsTimePickerLabel.localized,
                        selection: Binding(
                            get: {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm"
                                let date = formatter.date(from: userData.notificationTime) ?? Date()
                                return date
                            },
                            set: { newDate in
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm"
                                userData.notificationTime = formatter.string(from: newDate)
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            // MARK: - Reading Goal Selection
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKey.onboardingNotificationsReadingGoalLabel.localized)
                    .font(.headline)
                    .foregroundColor(.primary)

                Picker(LocalizationKey.onboardingNotificationsReadingGoalLabel.localized, selection: $userData.readingGoal) {
                    Text(LocalizationKey.onboardingNotificationsReadingGoalNone.localized).tag(Optional<ReadingGoal>(nil))
                    ForEach(ReadingGoal.allCases, id: \.self) { goal in
                        Text(goal.displayName).tag(Optional<ReadingGoal>(goal))
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
    OnboardingNotificationsView(
        userData: .constant(OnboardingData())
    )
}

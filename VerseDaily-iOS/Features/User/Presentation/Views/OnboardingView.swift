import SwiftUI

/// Main onboarding flow container
/// Axiom: Keep body <50 lines, extract subviews
struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                stepView
                footerView
            }
            .background(Color(.systemBackground))

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") { viewModel.error = nil }
        } message: {
            if let error = viewModel.error {
                Text(error.errorDescription ?? "Unknown error")
            }
        }
    }

    // MARK: - Subviews
    private var headerView: some View {
        VStack(spacing: 12) {
            Text(viewModel.currentStep.title)
                .font(.title2)
                .fontWeight(.bold)

            ProgressView(
                value: viewModel.currentStep.progress,
                total: 1.0
            )
            .frame(height: 4)
        }
        .padding(.all, 16)
        .background(Color(.systemGray6))
    }

    private var stepView: some View {
        ScrollView {
            VStack(spacing: 20) {
                switch viewModel.currentStep {
                case .profileInfo:
                    OnboardingProfileView(userData: $viewModel.userData)
                case .religiousPreferences:
                    OnboardingReligiousPreferencesView(userData: $viewModel.userData)
                case .themeLanguage:
                    OnboardingThemeLanguageView(userData: $viewModel.userData)
                case .notificationsGoal:
                    OnboardingNotificationsView(userData: $viewModel.userData)
                case .summary:
                    OnboardingSummaryView(userData: viewModel.userData)
                }

                // Validation errors
                if !viewModel.validationErrors.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.validationErrors, id: \.self) { error in
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.all, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(.all, 16)
        }
    }

    private var footerView: some View {
        HStack(spacing: 12) {
            // Back button
            if viewModel.currentStep.stepNumber > 1 {
                Button(action: { viewModel.previousStep() }) {
                    Text(LocalizationKey.onboardingBackButtonLabel.localized)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.blue)
                }
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 1))
            }

            // Next/Complete button
            Button(action: {
                if viewModel.currentStep == .summary {
                    Task {
                        await viewModel.completeOnboarding()
                        if viewModel.error == nil {
                            dismiss()
                        }
                    }
                } else {
                    viewModel.nextStep()
                }
            }) {
                Text(viewModel.currentStep == .summary ? LocalizationKey.onboardingCompleteButtonLabel.localized : LocalizationKey.onboardingNextButtonLabel.localized)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            // Skip button (only on first step)
            if viewModel.currentStep == .profileInfo {
                Button(action: {
                    Task {
                        await viewModel.skipOnboarding()
                        if viewModel.error == nil {
                            dismiss()
                        }
                    }
                }) {
                    Text(LocalizationKey.onboardingSkipButtonLabel.localized)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.gray)
                }
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
        }
        .padding(.all, 16)
    }
}

#Preview {
    OnboardingView(
        viewModel: OnboardingViewModel(
            userRepository: MockUserRepository(),
            completeOnboardingUseCase: MockCompleteOnboardingUseCase()
        )
    )
}

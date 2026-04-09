import Foundation
import Combine

/// OnboardingViewModel orchestrates the onboarding flow
/// Axiom: @MainActor for UI state, @Published for updates, error handling complete
/// Localization: All errors use LocalizationKey (no hardcoded strings)
@MainActor
final class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentStep: OnboardingStep = .profileInfo
    @Published var userData: OnboardingData = OnboardingData()
    @Published var isLoading = false
    @Published var error: OnboardingError?
    @Published var validationErrors: [String] = []

    // MARK: - Private Properties
    private let userRepository: UserRepositoryProtocol
    private let completeOnboardingUseCase: CompleteOnboardingUseCaseProtocol

    // MARK: - Init
    init(
        userRepository: UserRepositoryProtocol,
        completeOnboardingUseCase: CompleteOnboardingUseCaseProtocol
    ) {
        self.userRepository = userRepository
        self.completeOnboardingUseCase = completeOnboardingUseCase
    }

    // MARK: - Public Methods
    func nextStep() {
        validationErrors = []

        // Validate current step before advancing
        let validationResult = validateCurrentStep()
        if !validationResult.isValid {
            validationErrors = validationResult.errors
            return
        }

        // Advance to next step
        let _ = currentStep.nextStep()
    }

    func previousStep() {
        validationErrors = []
        let _ = currentStep.previousStep()
    }

    func skipOnboarding() {
        Task {
            await completeOnboarding()
        }
    }

    func completeOnboarding() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let settings = userData.toUserSettings()
            try await completeOnboardingUseCase.execute(with: settings)
        } catch let error as OnboardingError {
            self.error = error
        } catch {
            self.error = .persistenceFailed(error.localizedDescription)
        }
    }

    // MARK: - Private Methods
    private func validateCurrentStep() -> ValidationResult {
        switch currentStep {
        case .profileInfo:
            return userData.validateProfileInfo()
        case .religiousPreferences:
            return userData.validateReligiousPreferences()
        case .themeLanguage:
            return .success // Theme & language always valid
        case .notificationsGoal:
            return .success // Notifications & goal always valid
        case .summary:
            return .success // Summary just displays data
        }
    }
}

// MARK: - Onboarding Error
public enum OnboardingError: LocalizedError, Sendable {
    case invalidName
    case invalidEmail
    case persistenceFailed(String)
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .invalidName:
            return LocalizationKey.validationErrorNameRequired.localized
        case .invalidEmail:
            return LocalizationKey.validationErrorInvalidEmail.localized
        case .persistenceFailed(let msg):
            return LocalizationKey.onboardingErrorPersistenceFailed.localized(with: msg as CVarArg)
        case .unknownError:
            return LocalizationKey.onboardingErrorUnknown.localized
        }
    }
}

// MARK: - Protocols
public protocol CompleteOnboardingUseCaseProtocol: Sendable {
    func execute(with settings: UserSettings) async throws
}

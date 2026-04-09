import Foundation

/// Use case for completing onboarding and saving user settings
/// Axiom: One use case = one operation, dependencies injected
public protocol CompleteOnboardingUseCaseProtocol: Sendable {
    func execute(with settings: UserSettings) async throws
}

/// Implementation of CompleteOnboardingUseCase
/// Orchestrates: validate → save → return result
public final class CompleteOnboardingUseCase: CompleteOnboardingUseCaseProtocol, Sendable {
    private let userRepository: UserRepositoryProtocol

    // MARK: - Init
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }

    // MARK: - Public Methods
    /// Saves completed onboarding settings to repository
    /// - Parameter settings: Validated UserSettings with onboarding data
    /// - Throws: OnboardingError if persistence fails
    public func execute(with settings: UserSettings) async throws {
        do {
            try await userRepository.updateSettings(settings)
        } catch {
            // Map repository errors to domain errors
            throw mapError(error)
        }
    }

    // MARK: - Private Methods
    /// Maps repository/persistence errors to domain OnboardingError
    private func mapError(_ error: Error) -> OnboardingError {
        if let error = error as? OnboardingError {
            return error
        }

        // If it's a persistence error, wrap it
        if error.localizedDescription.contains("persistence") ||
           error.localizedDescription.contains("encode") ||
           error.localizedDescription.contains("decode") {
            return .persistenceFailed(error.localizedDescription)
        }

        // Default to unknown error
        return .unknownError
    }
}

import Foundation

/// Mock implementation for testing
public class MockCompleteOnboardingUseCase: CompleteOnboardingUseCaseProtocol {
    public var shouldFail = false
    public var error: OnboardingError = .unknownError
    public var savedSettings: UserSettings?

    public init() {}

    public func execute(with settings: UserSettings) async throws {
        savedSettings = settings

        if shouldFail {
            throw error
        }
    }
}

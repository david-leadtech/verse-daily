import Foundation

/// Domain errors specific to onboarding process
/// Maps to localization keys in UserSettings.swift
public enum OnboardingError: LocalizedError, Sendable {
    case persistenceFailed(String)
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .persistenceFailed(let message):
            return LocalizationKey.onboardingErrorPersistenceFailed.localized + ": \(message)"
        case .unknownError:
            return LocalizationKey.onboardingErrorUnknown.localized
        }
    }
}

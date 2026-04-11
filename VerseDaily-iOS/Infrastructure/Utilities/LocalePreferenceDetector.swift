import Foundation
import CoreModels

/// Detects and infers user preferences based on device locale
public struct LocalePreferenceDetector {
    /// Infers the most appropriate Biblical canon and language based on device locale
    /// - Returns: A tuple containing the inferred Canon and language code
    public static func inferDefaultPreferences(from locale: Locale = Locale.current) -> (canon: Canon, language: String) {
        let region = locale.region?.identifier ?? "US"
        let language = locale.language.languageCode?.identifier ?? "en"

        // Determine canon based on common religious traditions by region
        let canon: Canon
        switch region {
        // Spanish and Portuguese-speaking regions: likely Catholic
        case "ES", "PT", "MX", "AR", "CL", "CO", "PE", "VE", "EC", "BO", "PA", "CR", "DO", "CU", "BR":
            canon = .catholic
        // Greek-speaking regions: likely Orthodox
        case "GR":
            canon = .orthodox
        // Default: Protestant (most common globally)
        default:
            canon = .protestant
        }

        return (canon, language)
    }

    /// Get the preferred Bible version for a given region
    /// - Parameter locale: The locale to check (defaults to current device locale)
    /// - Returns: A localized Bible version identifier (e.g., "RVC" for Spanish, "KJV" for English)
    public static func preferredBibleVersion(for locale: Locale = Locale.current) -> String {
        let language = locale.language.languageCode?.identifier ?? "en"

        switch language {
        case "es":
            return "RVC" // Reina-Valera Contemporánea for Spanish
        case "pt":
            return "ARA" // Almeida Revisada Atualizada for Portuguese
        default:
            return "KJV" // King James Version as default
        }
    }
}

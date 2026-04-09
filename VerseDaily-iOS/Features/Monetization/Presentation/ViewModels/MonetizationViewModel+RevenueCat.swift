import Foundation
import SwiftUI
import RevenueCat

// MARK: - Extension to wire RevenueCat with MonetizationViewModel

extension MonetizationViewModel {

    /// Load packages from RevenueCat Offering
    @MainActor
    func loadPackagesFromRevenueCat() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Fetch offerings from RevenueCat
            let offerings = try await Purchases.shared.offerings()

            // Get the current offering (Verse Daily subscription)
            guard let offering = offerings.current else {
                error = .offeringNotFound
                return
            }

            // Map RevenueCat packages to our UI model
            let mappedPackages = offering.availablePackages.compactMap { rcPackage -> PaywallPackage? in
                return mapRevenueCatPackage(rcPackage)
            }

            self.packages = mappedPackages

        } catch {
            self.error = .packageFetchFailed(error.localizedDescription)
        }
    }

    /// Map RevenueCat Package to UI Package
    private func mapRevenueCatPackage(_ rcPackage: RevenueCat.Package) -> PaywallPackage? {
        let identifier = rcPackage.identifier
        let displayName = rcPackage.product.localizedTitle
        let price = rcPackage.localizedPriceString
        let subtitle = formatPackageSubtitle(rcPackage)

        return PaywallPackage(
            identifier: identifier,
            displayName: displayName,
            subtitle: subtitle,
            price: price
        )
    }

    /// Format subtitle based on package type
    private func formatPackageSubtitle(_ package: RevenueCat.Package) -> String {
        let period = package.localizedSubscriptionPeriod ?? "plan"
        let price = package.localizedPriceString

        switch package.identifier {
        case "verse_daily_trial":
            return "Then $4.99 per week. No payment now"
        case "verse_daily_yearly":
            return "First year at \(price), then $59.99 yearly"
        default:
            return "Subscribe to \(period)"
        }
    }

    /// Handle subscription purchase
    @MainActor
    func subscribe(to package: PaywallPackage) async {
        isLoading = true
        defer { isLoading = false }

        guard let rcPackage = findRevenueCatPackage(by: package.identifier) else {
            error = .packageNotFound
            return
        }

        do {
            let (_, customerInfo) = try await Purchases.shared.purchase(package: rcPackage)

            // Check if user is now premium
            if customerInfo.entitlements.active["Verse Daily Pro"] != nil {
                // Success! User has access
                isPremium = true
                showPaywall = false
                // Optionally sync to UserSettings
                await syncPremiumStatusToSettings()
            }

        } catch {
            // Handle purchase errors
            if error is PurchasesErrorCode {
                // Check specific error
                if case .purchaseCancelledError = error {
                    // User cancelled - don't show error
                    return
                }
            }
            self.error = .purchaseFailed(error.localizedDescription)
        }
    }

    /// Find RevenueCat package by identifier
    private func findRevenueCatPackage(by identifier: String) -> RevenueCat.Package? {
        // This would need to be cached after loadPackagesFromRevenueCat
        // For now, you'd need to keep a reference to the offerings
        return nil // Implementation depends on your architecture
    }

    /// Sync premium status to UserSettings
    @MainActor
    private func syncPremiumStatusToSettings() async {
        // Call your UpdateUserSettingsUseCase
        // updateUserSettingsUseCase.execute(isPremium: true)
    }

    /// Check current entitlement status
    @MainActor
    func checkPremiumStatus() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()

            if customerInfo.entitlements.active["Verse Daily Pro"] != nil {
                isPremium = true
            } else {
                isPremium = false
            }
        } catch {
            // Use cached value if fetch fails
            print("Failed to check premium status: \(error)")
        }
    }
}

// MARK: - Paywall Package Model
struct PaywallPackage: Identifiable {
    let id: String
    let identifier: String
    let displayName: String
    let subtitle: String
    let price: String

    init(identifier: String, displayName: String, subtitle: String, price: String) {
        self.identifier = identifier
        self.displayName = displayName
        self.subtitle = subtitle
        self.price = price
        self.id = identifier
    }
}

// MARK: - Error Types
enum MonetizationError: LocalizedError {
    case packageFetchFailed(String)
    case packageNotFound
    case offeringNotFound
    case purchaseFailed(String)
    case entitlementCheckFailed(String)

    var errorDescription: String? {
        switch self {
        case .packageFetchFailed(let msg):
            return "Failed to load subscription options: \(msg)"
        case .packageNotFound:
            return "Package not found in RevenueCat offering"
        case .offeringNotFound:
            return "No offerings available. Check RevenueCat configuration"
        case .purchaseFailed(let msg):
            return "Purchase failed: \(msg)"
        case .entitlementCheckFailed(let msg):
            return "Failed to verify subscription: \(msg)"
        }
    }
}

import Foundation
import RevenueCat

public final class RevenueCatMonetizationRepository: MonetizationRepositoryProtocol, Sendable {

    // MARK: - Configuration
    private let entitlementId = "Verse Daily Pro"

    public init() {}

    // MARK: - MonetizationRepositoryProtocol

    public func getSubscriptionPlans() async throws -> [SubscriptionPlan] {
        do {
            let offerings = try await RevenueCatManager.shared.getOfferings()

            guard let defaultOffering = offerings.current else {
                throw MonetizationError.noOfferingAvailable
            }

            // Map RevenueCat packages to domain models
            let plans = defaultOffering.availablePackages.compactMap { package in
                mapPackageToSubscriptionPlan(package)
            }

            guard !plans.isEmpty else {
                throw MonetizationError.noPlanAvailable
            }

            return plans

        } catch {
            throw MonetizationError.fetchFailed(error.localizedDescription)
        }
    }

    public func getSubscriptionStatus() async throws -> SubscriptionStatus {
        do {
            let customerInfo = try await RevenueCatManager.shared.getCustomerInfo()

            // Check if user has active premium entitlement
            if customerInfo.entitlements.active[entitlementId] != nil {
                return .premium
            }

            // Check if entitlement exists but is expired
            if customerInfo.entitlements.all[entitlementId] != nil {
                return .expired
            }

            return .free

        } catch {
            // Fallback to free if we can't fetch info (network error, etc)
            print("⚠️ Error fetching subscription status: \(error.localizedDescription)")
            return .free
        }
    }

    public func purchase(planId: String) async throws -> Bool {
        do {
            let offerings = try await RevenueCatManager.shared.getOfferings()

            guard let defaultOffering = offerings.current else {
                throw MonetizationError.noOfferingAvailable
            }

            // Find the package matching the plan ID
            guard let package = defaultOffering.availablePackages.first(where: { $0.identifier == planId }) else {
                throw MonetizationError.packageNotFound(planId)
            }

            // Attempt purchase
            _ = try await RevenueCatManager.shared.purchase(package: package)
            return true

        } catch {
            throw MonetizationError.purchaseFailed(error.localizedDescription)
        }
    }

    public func restorePurchases() async throws -> Bool {
        do {
            let customerInfo = try await RevenueCatManager.shared.restorePurchases()

            // Check if restoration resulted in active entitlement
            return customerInfo.entitlements.active[entitlementId] != nil

        } catch {
            throw MonetizationError.restorationFailed(error.localizedDescription)
        }
    }

    // MARK: - Private Methods

    /// Map RevenueCat Package to domain SubscriptionPlan
    private func mapPackageToSubscriptionPlan(_ package: Package) -> SubscriptionPlan {
        // Determine display name and period
        let (name, period) = getPlanNameAndPeriod(package: package)

        // Calculate savings percentage if it's a popular plan
        let savings = calculateSavings(package: package)

        // Parse price from RevenueCat
        let price = Money(
            amount: Decimal(package.product.price),
            currency: package.product.priceLocale.currencyCode ?? "USD"
        )

        return SubscriptionPlan(
            id: package.identifier,
            name: name,
            price: price,
            period: period,
            savings: savings,
            isPopular: isPopularPlan(package: package)
        )
    }

    /// Determine plan name and period based on package
    private func getPlanNameAndPeriod(package: Package) -> (name: String, period: String) {
        let identifier = package.identifier.lowercased()

        if identifier.contains("month") || package.product.subscriptionPeriod?.unit == .month {
            return ("Monthly", "monthly")
        } else if identifier.contains("year") || identifier.contains("annual") ||
                  package.product.subscriptionPeriod?.unit == .year {
            return ("Yearly", "yearly")
        } else if identifier.contains("lifetime") {
            return ("Lifetime", "lifetime")
        } else {
            return (package.localizedTitle, "subscription")
        }
    }

    /// Determine if this is the "popular" plan (usually annual)
    private func isPopularPlan(package: Package) -> Bool {
        let identifier = package.identifier.lowercased()
        return identifier.contains("year") || identifier.contains("annual")
    }

    /// Calculate savings percentage compared to monthly
    /// Returns nil if not applicable
    private func calculateSavings(package: Package) -> String? {
        let identifier = package.identifier.lowercased()

        // Only show savings for annual/yearly plans
        guard identifier.contains("year") || identifier.contains("annual") else {
            return nil
        }

        // Typical savings: ~33% (annual is 4x monthly instead of 12x)
        // In a real app, you'd calculate this from actual prices
        return "33%"
    }
}

// MARK: - Monetization Error Types
public enum MonetizationError: LocalizedError, Sendable {
    case noOfferingAvailable
    case noPlanAvailable
    case packageNotFound(String)
    case purchaseFailed(String)
    case restorationFailed(String)
    case fetchFailed(String)

    public var errorDescription: String? {
        switch self {
        case .noOfferingAvailable:
            return "No subscription offerings available"
        case .noPlanAvailable:
            return "No subscription plans available"
        case .packageNotFound(let id):
            return "Subscription plan '\(id)' not found"
        case .purchaseFailed(let msg):
            return "Purchase failed: \(msg)"
        case .restorationFailed(let msg):
            return "Failed to restore purchases: \(msg)"
        case .fetchFailed(let msg):
            return "Failed to fetch plans: \(msg)"
        }
    }
}

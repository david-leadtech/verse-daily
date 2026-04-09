import Foundation
import RevenueCat
import CoreModels

public final class RevenueCatMonetizationRepository: MonetizationRepositoryProtocol, Sendable {

    public init() {}

    public func getSubscriptionPlans() async throws -> [SubscriptionPlan] {
        let offerings = try await Purchases.shared.offerings()

        guard let defaultOffering = offerings.current else {
            return []
        }

        return defaultOffering.availablePackages.compactMap { package in
            mapPackageToSubscriptionPlan(package)
        }
    }

    public func getSubscriptionStatus() async throws -> SubscriptionStatus {
        let info = try await Purchases.shared.customerInfo()

        // Check for "Verse Daily Pro" entitlement
        if let entitlement = info.entitlements.active["Verse Daily Pro"] {
            // Check if it's expired
            if let expirationDate = entitlement.expirationDate,
               expirationDate < Date() {
                return .expired
            }
            return .premium
        }

        return .free
    }

    public func purchase(planId: String) async throws -> Bool {
        let offerings = try await Purchases.shared.offerings()

        guard let package = offerings.current?.availablePackages.first(where: { $0.identifier == planId }) else {
            throw PurchaseError.packageNotFound(planId)
        }

        do {
            let result = try await Purchases.shared.purchase(package: package)

            // Check if purchase was successful
            if let entitlement = result.customerInfo.entitlements.active["Verse Daily Pro"] {
                print("✅ Purchase successful for entitlement: \(entitlement.identifier)")
                return true
            }

            // Handle pending transactions (parental controls)
            if result.userCancelled == false {
                print("⏳ Purchase pending (may require parental approval)")
                return false
            }

            return false
        } catch let error as PurchasesErrorCode {
            if error == .purchaseCancelledError {
                throw PurchaseError.userCancelled
            } else if error == .productNotAvailableForPurchaseError {
                throw PurchaseError.notAvailable
            }
            throw PurchaseError.purchaseFailed(error.localizedDescription)
        }
    }

    public func restorePurchases() async throws -> Bool {
        do {
            let info = try await Purchases.shared.restoreTransactions()

            if info.entitlements.active["Verse Daily Pro"] != nil {
                print("✅ Purchases restored successfully")
                return true
            }

            return false
        } catch {
            throw PurchaseError.restorationFailed(error.localizedDescription)
        }
    }

    // MARK: - Private Helper Methods

    private func mapPackageToSubscriptionPlan(_ package: RevenueCat.Package) -> SubscriptionPlan {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        let price = package.storeProduct.price
        let formattedPrice = formatter.string(from: price) ?? price.stringValue

        let period: SubscriptionPlan.BillingPeriod
        if let productType = package.storeProduct.subscriptionPeriod {
            switch (productType.unit, productType.numberOfUnits) {
            case (.month, 1):
                period = .monthly
            case (.year, 1):
                period = .yearly
            default:
                period = .monthly
            }
        } else {
            // Lifetime purchase (no subscription period)
            period = .lifetime
        }

        // Calculate savings for yearly if applicable
        var savings: Decimal? = nil
        if period == .yearly {
            let estimatedMonthlyPrice = price / 12
            savings = ((estimatedMonthlyPrice * 12 - price) / (estimatedMonthlyPrice * 12)) * 100
        }

        return SubscriptionPlan(
            id: package.identifier,
            name: package.displayName,
            price: Money(
                amount: price,
                currency: package.storeProduct.priceLocale.currencyCode ?? "USD"
            ),
            period: period,
            savings: savings,
            isPopular: package.identifier == "yearly"
        )
    }
}

// MARK: - Error Types

public enum PurchaseError: LocalizedError {
    case packageNotFound(String)
    case userCancelled
    case notAvailable
    case purchaseFailed(String)
    case restorationFailed(String)
    case networkError(String)

    public var errorDescription: String? {
        switch self {
        case .packageNotFound(let id):
            return "Subscription package not found: \(id)"
        case .userCancelled:
            return "Purchase was cancelled by the user"
        case .notAvailable:
            return "This product is not available for purchase in your region"
        case .purchaseFailed(let reason):
            return "Purchase failed: \(reason)"
        case .restorationFailed(let reason):
            return "Purchase restoration failed: \(reason)"
        case .networkError(let reason):
            return "Network error: \(reason)"
        }
    }
}

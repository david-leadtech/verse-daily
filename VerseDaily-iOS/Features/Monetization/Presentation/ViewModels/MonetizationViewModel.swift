import Foundation
import Combine

@MainActor
public final class MonetizationViewModel: ObservableObject {
    // MARK: - State
    @Published public var plans: [SubscriptionPlanDTO] = []
    @Published public var selectedPlanId: String?
    @Published public var isLoading: Bool = false
    @Published public var isSubscribed: Bool = false
    @Published public var error: PurchaseError?
    @Published public var isInFallbackMode: Bool = false
    @Published public var fallbackWarning: String?

    // MARK: - Dependencies
    private let getPlansUseCase: GetSubscriptionPlansUseCase
    private let subscribeUseCase: SubscribeUseCase

    public init(getPlansUseCase: GetSubscriptionPlansUseCase, subscribeUseCase: SubscribeUseCase) {
        self.getPlansUseCase = getPlansUseCase
        self.subscribeUseCase = subscribeUseCase
    }

    // MARK: - Public Methods

    /// Load subscription plans from RevenueCat
    /// Falls back to mock data if RC unavailable
    public func loadPlans() async {
        isLoading = true
        error = nil

        do {
            self.plans = try await getPlansUseCase.execute()
            self.isInFallbackMode = false
            self.selectedPlanId = plans.first(where: { $0.isPopular })?.id ?? plans.first?.id

        } catch {
            // RevenueCat failed, load fallback mock plans
            self.plans = getMockPlans()
            self.isInFallbackMode = true
            self.fallbackWarning = "Showing offline plans. Purchases may require internet connection."
            self.selectedPlanId = plans.first(where: { $0.isPopular })?.id ?? plans.first?.id

            print("⚠️ RevenueCat unavailable, using fallback plans: \(error.localizedDescription)")
        }

        isLoading = false
    }

    /// Attempt subscription purchase
    /// Fails gracefully in fallback mode if RC unavailable
    public func subscribe() async {
        guard let planId = selectedPlanId else {
            error = .purchaseFailed("No plan selected")
            return
        }

        isLoading = true
        error = nil

        do {
            try await subscribeUseCase.execute(planId: planId)
            self.isSubscribed = true

        } catch {
            // Handle any purchase error
            self.error = .purchaseFailed(error.localizedDescription)
        }

        isLoading = false
    }

    /// Clear error state
    public func clearError() {
        error = nil
    }

    // MARK: - Private Methods

    /// Get mock plans for fallback mode
    private func getMockPlans() -> [SubscriptionPlanDTO] {
        [
            SubscriptionPlanDTO(
                id: "src_monthly",
                name: "Monthly",
                priceLabel: "$4.99",
                period: "monthly",
                savings: nil,
                isPopular: false
            ),
            SubscriptionPlanDTO(
                id: "src_annual",
                name: "Yearly",
                priceLabel: "$39.99",
                period: "yearly",
                savings: "33%",
                isPopular: true
            ),
            SubscriptionPlanDTO(
                id: "src_lifetime",
                name: "Lifetime",
                priceLabel: "$99.99",
                period: "lifetime",
                savings: nil,
                isPopular: false
            )
        ]
    }

}

// MARK: - Purchase Error Types
public enum PurchaseError: LocalizedError, Sendable {
    case userCancelled
    case purchaseFailed(String)
    case restorationFailed(String)
    case networkError(String)

    public var errorDescription: String? {
        switch self {
        case .userCancelled:
            return "Purchase cancelled"
        case .purchaseFailed(let msg):
            return "Purchase failed: \(msg)"
        case .restorationFailed(let msg):
            return "Could not restore purchases: \(msg)"
        case .networkError(let msg):
            return "Network error: \(msg)"
        }
    }
}

import Foundation
import Combine
import RevenueCat

// MARK: - RevenueCat Manager
/// Singleton manager for RevenueCat SDK operations
/// Handles initialization, entitlement checking, and subscription status monitoring
@MainActor
public final class RevenueCatManager: ObservableObject, Sendable {
    public static let shared = RevenueCatManager()

    // MARK: - Published Properties
    @Published public private(set) var isInitialized = false
    @Published public private(set) var customerInfo: CustomerInfo?
    @Published public private(set) var error: RevenueCatError?

    // MARK: - Configuration
    // Test API Key for development - switch to production before App Store release
    private let testApiKey = "sk_GWaRZMPDHSYnuWIuhRaBReqfMQXnR"
    private let entitlementId = "Verse Daily Pro"

    // MARK: - Initialization
    private init() {}

    // MARK: - Public Methods

    /// Initialize RevenueCat SDK
    /// Must be called once at app launch
    public func initialize() async {
        guard !isInitialized else { return }

        do {
            print("🔄 Initializing RevenueCat")

            // Configure RevenueCat SDK
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: testApiKey)

            // Fetch initial customer info
            let info = try await Purchases.shared.customerInfo()
            self.customerInfo = info

            // Set up listener for subscription changes
            setupCustomerInfoListener()

            self.isInitialized = true
            print("✅ RevenueCat initialized successfully")

        } catch {
            self.error = RevenueCatError.initializationFailed(error.localizedDescription)
            print("❌ RevenueCat initialization failed: \(error.localizedDescription)")
        }
    }

    /// Check if user has the premium entitlement
    /// - Returns: `true` if user is premium, `false` otherwise
    public func isPremium() async -> Bool {
        do {
            let info = try await Purchases.shared.customerInfo()
            let hasEntitlement = info.entitlements.active[entitlementId] != nil
            return hasEntitlement
        } catch {
            print("⚠️ Error checking entitlement: \(error.localizedDescription)")
            return false
        }
    }

    /// Get current customer information
    /// - Returns: CustomerInfo with subscription and entitlement details
    public func getCustomerInfo() async throws -> CustomerInfo {
        let info = try await Purchases.shared.customerInfo()
        self.customerInfo = info
        return info
    }

    /// Get available subscription offerings
    /// - Returns: Offerings with packages for purchase
    public func getOfferings() async throws -> Offerings {
        return try await Purchases.shared.offerings()
    }

    /// Purchase a subscription package
    /// - Parameter package: The package to purchase
    /// - Returns: CustomerInfo after successful purchase
    public func purchase(package: Package) async throws -> CustomerInfo {
        do {
            let (transaction, customerInfo) = try await Purchases.shared.purchase(package: package)
            self.customerInfo = customerInfo
            print("✅ Purchase successful: \(transaction.productIdentifier)")
            return customerInfo
        } catch let error as PurchasesErrorCode {
            throw RevenueCatError.purchaseFailed(error.description)
        } catch {
            throw RevenueCatError.purchaseFailed(error.localizedDescription)
        }
    }

    /// Restore previous purchases
    /// - Returns: CustomerInfo after restoration
    public func restorePurchases() async throws -> CustomerInfo {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            self.customerInfo = customerInfo
            print("✅ Purchases restored")
            return customerInfo
        } catch {
            throw RevenueCatError.restorationFailed(error.localizedDescription)
        }
    }

    /// Get entitlement expiration date if exists
    /// - Returns: Date when entitlement expires, or nil if not premium
    public func getEntitlementExpirationDate() -> Date? {
        return customerInfo?.entitlements.active[entitlementId]?.expirationDate
    }

    /// Check if premium entitlement is still valid (not expired)
    /// - Returns: `true` if premium and not expired
    public func isPremiumAndValid() -> Bool {
        guard let entitlement = customerInfo?.entitlements.active[entitlementId] else {
            return false
        }

        // Check if expiration date is in the future
        if let expirationDate = entitlement.expirationDate {
            return expirationDate > Date()
        }

        // Lifetime purchase (no expiration)
        return true
    }

    // MARK: - Private Methods

    /// Set up listener for automatic customer info updates
    /// Automatically refreshes when subscription status changes
    private func setupCustomerInfoListener() {
        // Listen for customer info changes
        Purchases.shared.customerInfoStream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] customerInfo in
                self?.customerInfo = customerInfo
                print("📡 Customer info updated via stream")
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - RevenueCat Error Types
public enum RevenueCatError: LocalizedError, Sendable {
    case initializationFailed(String)
    case purchaseFailed(String)
    case restorationFailed(String)
    case fetchFailed(String)

    public var errorDescription: String? {
        switch self {
        case .initializationFailed(let msg):
            return "Failed to initialize RevenueCat: \(msg)"
        case .purchaseFailed(let msg):
            return "Purchase failed: \(msg)"
        case .restorationFailed(let msg):
            return "Failed to restore purchases: \(msg)"
        case .fetchFailed(let msg):
            return "Failed to fetch data: \(msg)"
        }
    }
}

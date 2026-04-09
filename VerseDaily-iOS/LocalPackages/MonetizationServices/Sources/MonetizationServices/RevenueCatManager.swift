import Foundation
import RevenueCat
import Combine

@MainActor
public final class RevenueCatManager: ObservableObject {
    public static let shared = RevenueCatManager()

    @Published public private(set) var customerInfo: CustomerInfo?
    @Published public private(set) var isInitialized = false
    @Published public private(set) var error: Error?

    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "test_ZrHINtPwuOTHWiqoLLnYZsCYfBi"

    private init() {
        setupCustomerInfoObserver()
    }

    public func initialize() async {
        guard !isInitialized else { return }

        do {
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: apiKey)

            // Fetch initial customer info
            let info = try await Purchases.shared.customerInfo()
            await MainActor.run {
                self.customerInfo = info
                self.isInitialized = true
            }
        } catch {
            await MainActor.run {
                self.error = error
                print("❌ RevenueCat initialization failed: \(error.localizedDescription)")
            }
        }
    }

    private func setupCustomerInfoObserver() {
        // Listen for customer info updates
        Purchases.shared.customerInfoStream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] info in
                self?.customerInfo = info
            }
            .store(in: &cancellables)
    }

    public func hasEntitlement(_ entitlementId: String) -> Bool {
        guard let info = customerInfo else { return false }
        return info.entitlements.active[entitlementId] != nil
    }

    public func restoreTransactions() async throws {
        let info = try await Purchases.shared.restoreTransactions()
        await MainActor.run {
            self.customerInfo = info
        }
    }

    deinit {
        cancellables.removeAll()
    }
}

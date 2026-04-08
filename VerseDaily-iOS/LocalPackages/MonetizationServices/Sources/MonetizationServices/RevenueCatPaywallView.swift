import SwiftUI
import RevenueCat

/// RevenueCat PaywallView wrapper providing:
/// - Native RevenueCat paywall UI with A/B testing support
/// - Automatic updates from RevenueCat dashboard
/// - Professional design and animations
/// - Error handling with graceful fallback
public struct RevenueCatPaywallView: View {
    @Environment(\.dismiss) var dismiss
    var onPurchaseComplete: (() -> Void)?
    var onDismiss: (() -> Void)?

    @State private var error: Error?
    @State private var showError = false

    public init(
        onPurchaseComplete: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.onPurchaseComplete = onPurchaseComplete
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            // RevenueCat Paywall (if available)
            if #available(iOS 16.0, *) {
                PaywallView(displayCloseButton: true)
                    .onPurchaseCompleted { customerInfo in
                        // Verify entitlement after purchase
                        if customerInfo.entitlements.active["Verse Daily Pro"] != nil {
                            onPurchaseComplete?()
                        }
                    }
                    .onDismissed {
                        onDismiss?()
                        dismiss()
                    }
                    .onError { error in
                        self.error = error
                        self.showError = true
                    }
            } else {
                // Fallback for older iOS versions
                VStack {
                    Text("Subscription Required")
                        .font(.title2.bold())
                    Spacer()
                    Text("Unable to load paywall on this device")
                        .foregroundColor(.secondary)
                    Spacer()
                    Button("Dismiss") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .alert("Purchase Error", isPresented: $showError, presenting: error) { _ in
            Button("OK") { showError = false }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
}

#Preview {
    RevenueCatPaywallView()
}

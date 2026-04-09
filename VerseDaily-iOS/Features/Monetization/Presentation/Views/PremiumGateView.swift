import SwiftUI
import DesignSystem

/// Wrapper view that gates content behind premium subscription
/// Shows paywall if user is not premium
struct PremiumGateView<Content: View>: View {
    @State private var isPremium = false
    @State private var isLoading = true
    @State private var showPaywall = false

    let featureName: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            if isLoading {
                loadingView
            } else if isPremium {
                content()
            } else {
                premiumPromptView
            }
        }
        .task {
            await checkPremiumStatus()
        }
        .sheet(isPresented: $showPaywall) {
            SubscriptionView(viewModel: DependencyContainer.shared.resolveMonetizationViewModel())
        }
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
                .tint(DS.Tokens.Colors.tint)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.Tokens.Colors.background)
    }

    private var premiumPromptView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            Image(systemName: icon)
                .font(.system(size: 64, weight: .light))
                .foregroundColor(DS.Tokens.Colors.tint.opacity(0.6))

            // Title & Description
            VStack(spacing: 12) {
                Text("Premium Feature")
                    .font(DS.Tokens.Typography.playfairBold(size: 28))
                    .foregroundColor(DS.Tokens.Colors.text)

                Text("Unlock \(featureName) with Premium access")
                    .font(DS.Tokens.Typography.interRegular(size: 16))
                    .foregroundColor(DS.Tokens.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }

            // Benefits
            VStack(alignment: .leading, spacing: 12) {
                benefitRow(icon: "sparkles", text: "Unlimited access")
                benefitRow(icon: "bell.fill", text: "Daily notifications")
                benefitRow(icon: "xmark.circle.fill", text: "Ad-free experience")
            }
            .padding(20)
            .background(DS.Tokens.Colors.surface)
            .cornerRadius(16)

            Spacer()

            // CTA Button
            Button(action: { showPaywall = true }) {
                Text("Upgrade to Premium")
                    .font(DS.Tokens.Typography.interMedium(size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(DS.Tokens.Colors.tint)
                    .cornerRadius(12)
            }

            // Secondary CTA
            Button(action: {}) {
                Text("Maybe Later")
                    .font(DS.Tokens.Typography.interMedium(size: 16))
                    .foregroundColor(DS.Tokens.Colors.tint)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(DS.Tokens.Colors.tint.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DS.Tokens.Colors.background)
    }

    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(DS.Tokens.Colors.tint)
                .frame(width: 20)

            Text(text)
                .font(DS.Tokens.Typography.interRegular(size: 14))
                .foregroundColor(DS.Tokens.Colors.text)

            Spacer()
        }
    }

    private func checkPremiumStatus() async {
        do {
            let isPremiumNow = await MonetizationIntegration(
                repository: DependencyContainer.shared.monetizationRepository
            ).isPremiumUser()

            await MainActor.run {
                self.isPremium = isPremiumNow
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

#Preview {
    PremiumGateView(
        featureName: "Prayer Journal",
        icon: "pencil.and.outline"
    ) {
        VStack {
            Text("Prayer Journal Content")
                .font(.title)
        }
    }
}

import SwiftUI

// MARK: - Main Paywall (Bible Chat Style)
struct PaywallTemplate: View {
    @State private var selectedPackageId: String?
    @State private var wantsFreeOnly: Bool = false

    let packages: [Package]  // Comes from RevenueCat
    var onSubscribe: (Package) -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.972, green: 0.963, blue: 0.949)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Close button
                    HStack {
                        Button(action: onClose) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    VStack(spacing: 28) {
                        // Illustration
                        illustrationSection

                        // Title
                        titleSection

                        // Benefits
                        benefitsSection

                        // Free trial toggle
                        freeTrialToggle

                        // Pricing options (from RevenueCat)
                        if !wantsFreeOnly {
                            pricingSection
                        }

                        // Legal text
                        legalSection

                        // CTA
                        ctaButton

                        // Footer
                        footerSection
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Illustration
    private var illustrationSection: some View {
        ZStack {
            Circle()
                .fill(Color(red: 1.0, green: 0.957, blue: 0.843))
                .frame(width: 120, height: 120)

            Image(systemName: "leaf.fill")
                .font(.system(size: 48, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    // MARK: - Title
    private var titleSection: some View {
        Text("Unlock Ultimate Peace in God's Guidance")
            .font(.system(size: 28, weight: .semibold))
            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.15))
            .multilineTextAlignment(.center)
            .lineSpacing(2)
    }

    // MARK: - Benefits
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            BenefitRow(text: "Find answers in the Bible")
            BenefitRow(text: "Resolve life issues with God's Word")
            BenefitRow(text: "Ask as many questions as you need")
        }
    }

    // MARK: - Free Trial Toggle
    private var freeTrialToggle: some View {
        HStack {
            Text("I want to try the app for free")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.15))

            Spacer()

            Toggle("", isOn: $wantsFreeOnly)
                .labelsHidden()
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.8, green: 0.8, blue: 0.8), lineWidth: 1.5)
        )
    }

    // MARK: - Pricing Options (Dynamic from RevenueCat)
    private var pricingSection: some View {
        VStack(spacing: 12) {
            ForEach(packages, id: \.identifier) { package in
                PricingOptionCard(
                    package: package,
                    isPopular: package.identifier == "verse_daily_yearly",
                    isSelected: selectedPackageId == package.identifier,
                    onTap: {
                        selectedPackageId = package.identifier
                    }
                )
            }
        }
    }

    // MARK: - Legal Text
    private var legalSection: some View {
        VStack(spacing: 4) {
            Text("Cancel anytime before May 4 2025.")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.15))

            Text("No risks, no charges.")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
        }
        .multilineTextAlignment(.center)
    }

    // MARK: - CTA Button
    private var ctaButton: some View {
        Button(action: {
            if let selectedId = selectedPackageId,
               let selectedPackage = packages.first(where: { $0.identifier == selectedId }) {
                onSubscribe(selectedPackage)
            }
        }) {
            HStack(spacing: 8) {
                Text("Try for Free")
                    .font(.system(size: 16, weight: .semibold))

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()
            }
            .foregroundColor(.white)
            .frame(height: 54)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.22, green: 0.22, blue: 0.27))
            .cornerRadius(14)
        }
        .disabled(selectedPackageId == nil)
    }

    // MARK: - Footer Links
    private var footerSection: some View {
        HStack(spacing: 8) {
            Link("Terms of use", destination: URL(string: "https://example.com")!)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))

            Text("•")
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))

            Link("Privacy policy", destination: URL(string: "https://example.com")!)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))

            Text("•")
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))

            Link("Restore", destination: URL(string: "https://example.com")!)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
        }
        .multilineTextAlignment(.center)
    }
}

// MARK: - Benefit Row
struct BenefitRow: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(red: 0.22, green: 0.22, blue: 0.27))

            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.15))

            Spacer()
        }
    }
}

// MARK: - Pricing Option Card
struct PricingOptionCard: View {
    let package: Package
    let isPopular: Bool
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(package.displayName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.15))

                        Text(package.subtitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            .lineSpacing(2)
                    }

                    Spacer()

                    if isPopular {
                        Text("SAVE 88%")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(red: 0.95, green: 0.29, blue: 0.29))
                            .cornerRadius(6)
                    }
                }

                if isSelected {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.22, green: 0.22, blue: 0.27))

                        Text("Selected")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(red: 0.22, green: 0.22, blue: 0.27))

                        Spacer()
                    }
                }
            }
            .padding(14)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color(red: 0.22, green: 0.22, blue: 0.27) : Color(red: 0.9, green: 0.9, blue: 0.9),
                        lineWidth: isSelected ? 2 : 1.5
                    )
            )
        }
    }
}

// MARK: - Package Model (from RevenueCat)
struct Package: Identifiable {
    let id: String
    let identifier: String
    let displayName: String
    let subtitle: String
    let price: String

    // Example initialization from RevenueCat Package
    init(identifier: String, displayName: String, subtitle: String, price: String) {
        self.identifier = identifier
        self.displayName = displayName
        self.subtitle = subtitle
        self.price = price
        self.id = identifier
    }
}

// MARK: - Preview
#Preview {
    PaywallTemplate(
        packages: [
            Package(
                identifier: "verse_daily_trial",
                displayName: "7 days Free Trial",
                subtitle: "Then $4.99 per week. No payment now",
                price: "Free"
            ),
            Package(
                identifier: "verse_daily_yearly",
                displayName: "Yearly Access",
                subtitle: "$29.99 for the first year, then $59.99 yearly",
                price: "$29.99"
            )
        ],
        onSubscribe: { package in print("Subscribe: \(package.identifier)") },
        onClose: { print("Close") }
    )
}

// MARK: - Preview
#Preview {
    PaywallTemplate(
        plans: [
            SubscriptionPlan(
                id: "monthly",
                name: "Monthly",
                price: 9.99,
                period: .month,
                type: .monthly
            ),
            SubscriptionPlan(
                id: "annual",
                name: "Annual",
                price: 79.99,
                period: .year,
                type: .annual
            ),
            SubscriptionPlan(
                id: "lifetime",
                name: "Lifetime",
                price: 199.99,
                period: .oneTime,
                type: .lifetime
            )
        ],
        onSubscribe: { _ in }
    )
}

// MARK: - Mock SubscriptionPlan (if needed for preview)
struct SubscriptionPlan: Identifiable {
    let id: String
    let name: String
    let price: Double
    let period: BillingPeriod
    let type: PlanType

    var displayName: String { name }

    var priceDisplay: String {
        switch period {
        case .month:
            return "$\(String(format: "%.2f", price))/month"
        case .year:
            return "$\(String(format: "%.2f", price))/year"
        case .oneTime:
            return "$\(String(format: "%.2f", price))"
        }
    }
}

enum BillingPeriod {
    case month
    case year
    case oneTime
}

enum PlanType {
    case monthly
    case annual
    case lifetime
}

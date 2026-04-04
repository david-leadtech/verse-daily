import SwiftUI

struct SubscriptionView: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @Environment(\.dismiss) var dismiss
    
    private let features = [
        ("book.closed.fill", "All devotionals & reflections"),
        ("bell.slash.fill", "Ad-free experience"),
        ("square.stack.3d.up.fill", "Multiple Bible translations"),
        ("photo.fill", "Premium verse wallpapers"),
        ("square.and.arrow.up.fill", "Beautiful sharing templates"),
        ("heart.fill", "Unlimited saved verses")
    ]
    
    var body: some View {
        ZStack {
            DS.Tokens.Colors.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    
                    VStack(spacing: 28) {
                        featuresSection
                        plansSection
                        subscribeButton
                        disclaimer
                    }
                    .padding(.vertical, 28)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            closeButton
        }
        .onAppear {
            Task { await viewModel.loadPlans() }
        }
        .onChange(of: viewModel.isSubscribed) { subscribed in
            if subscribed {
                dismiss()
            }
        }
    }
    
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Placeholder for Hero Image
            LinearGradient(
                colors: [Color(hex: "1E0C02").opacity(0.8), Color(hex: "3D1A05").opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 280)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Unlock Premium")
                    .font(DS.Tokens.Typography.playfairBold(size: 32))
                    .foregroundColor(.white)
                
                Text("Everything you need for a richer, more personal walk with Christ — every single day.")
                    .font(DS.Tokens.Typography.interRegular(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(4)
            }
            .padding(28)
        }
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(features, id: \.1) { icon, text in
                HStack(spacing: 14) {
                    ZStack {
                        DS.Tokens.Colors.tint.opacity(0.12)
                            .frame(width: 40, height: 40)
                            .cornerRadius(12)
                        Image(systemName: icon)
                            .foregroundColor(DS.Tokens.Colors.tint)
                            .font(.system(size: 18))
                    }
                    
                    Text(text)
                        .font(DS.Tokens.Typography.interMedium(size: 15))
                        .foregroundColor(DS.Tokens.Colors.text)
                }
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var plansSection: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.plans) { plan in
                planCard(plan)
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func planCard(_ plan: SubscriptionPlanDTO) -> some View {
        Button(action: { viewModel.selectedPlanId = plan.id }) {
            VStack(spacing: 0) {
                if plan.isPopular {
                    Text("Best Value")
                        .font(DS.Tokens.Typography.interMedium(size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(DS.Tokens.Colors.accent)
                }
                
                HStack(spacing: 14) {
                    // Radio Button
                    ZStack {
                        Circle()
                            .stroke(viewModel.selectedPlanId == plan.id ? DS.Tokens.Colors.accent : DS.Tokens.Colors.border, lineWidth: 2)
                            .frame(width: 22, height: 22)
                        if viewModel.selectedPlanId == plan.id {
                            Circle()
                                .fill(DS.Tokens.Colors.accent)
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(plan.name)
                            .font(DS.Tokens.Typography.interMedium(size: 16))
                            .foregroundColor(DS.Tokens.Colors.text)
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text(plan.price)
                                .font(DS.Tokens.Typography.playfairBold(size: 20))
                                .foregroundColor(DS.Tokens.Colors.text)
                            Text("/ \(plan.period)")
                                .font(DS.Tokens.Typography.interRegular(size: 14))
                                .foregroundColor(DS.Tokens.Colors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    if let savings = plan.savings {
                        Text(savings)
                            .font(DS.Tokens.Typography.interMedium(size: 12))
                            .foregroundColor(DS.Tokens.Colors.olive)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(DS.Tokens.Colors.olive.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(18)
            }
            .background(DS.Tokens.Colors.surface)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.selectedPlanId == plan.id ? DS.Tokens.Colors.accent : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var subscribeButton: some View {
        Button(action: {
            Task { await viewModel.subscribe() }
        }) {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "C5963A"), Color(hex: "8B6914")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Subscribe Now")
                        .font(DS.Tokens.Typography.interMedium(size: 18))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .cornerRadius(16)
        }
        .padding(.horizontal, 24)
        .disabled(viewModel.isLoading)
    }
    
    private var disclaimer: some View {
        Text("Cancel anytime. No commitment required.\nBy subscribing, you agree to our Terms of Use and Privacy Policy.")
            .font(DS.Tokens.Typography.interRegular(size: 12))
            .foregroundColor(DS.Tokens.Colors.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .lineSpacing(4)
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            Spacer()
        }
    }
}

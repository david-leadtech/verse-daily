import SwiftUI
import DesignSystem
import CoreModels

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var showingSubscription = false
    @State private var showingOnboarding = false

    var body: some View {
        NavigationView {
            ZStack {
                DS.Tokens.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        // Section: My Profile
                        VStack(alignment: .leading, spacing: 10) {
                            sectionTitle("My Profile")

                            VStack(spacing: 0) {
                                settingRow(
                                    icon: "person.fill",
                                    color: DS.Tokens.Colors.navy,
                                    label: "Name"
                                ) {
                                    TextField("Your name", text: $viewModel.userName)
                                        .font(DS.Tokens.Typography.interRegular(size: 14))
                                        .foregroundColor(DS.Tokens.Colors.text)
                                        .multilineTextAlignment(.trailing)
                                }

                                divider

                                settingRow(
                                    icon: "envelope.fill",
                                    color: DS.Tokens.Colors.tint,
                                    label: "Email",
                                    description: "Optional"
                                ) {
                                    TextField("your@email.com", text: $viewModel.userEmail)
                                        .font(DS.Tokens.Typography.interRegular(size: 14))
                                        .foregroundColor(DS.Tokens.Colors.text)
                                        .multilineTextAlignment(.trailing)
                                }

                                divider

                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "book.fill")
                                            .foregroundColor(DS.Tokens.Colors.accent)
                                            .font(.system(size: 16, weight: .semibold))

                                        Text("Biblical Tradition")
                                            .font(DS.Tokens.Typography.interMedium(size: 16))
                                            .foregroundColor(DS.Tokens.Colors.text)

                                        Spacer()
                                    }

                                    HStack(spacing: 8) {
                                        ForEach(Canon.allCases, id: \.self) { canon in
                                            canonButton(for: canon)
                                        }
                                    }
                                }
                                .padding(16)

                                divider

                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Reading Preferences")
                                        .font(DS.Tokens.Typography.interMedium(size: 14))
                                        .foregroundColor(DS.Tokens.Colors.text)

                                    VStack(spacing: 8) {
                                        ForEach(ReadingPreference.allCases, id: \.self) { preference in
                                            Toggle(preference.displayName, isOn: .init(
                                                get: { viewModel.readingPreferences.contains(preference) },
                                                set: { _ in viewModel.updateReadingPreference(preference) }
                                            ))
                                            .font(DS.Tokens.Typography.interRegular(size: 13))
                                            .tint(DS.Tokens.Colors.accent)
                                        }
                                    }
                                }
                                .padding(16)
                            }
                            .background(DS.Tokens.Colors.surface)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DS.Tokens.Colors.border, lineWidth: 0.5))
                        }
                        .padding(.horizontal, 20)

                        // Section: Preferences
                        VStack(alignment: .leading, spacing: 10) {
                            sectionTitle("Preferences")
                            
                            VStack(spacing: 0) {
                                settingRow(
                                    icon: "bell",
                                    color: DS.Tokens.Colors.navy,
                                    label: "Daily Notifications",
                                    description: "Receive your daily verse reminder"
                                ) {
                                    Toggle("", isOn: Binding(
                                        get: { viewModel.notificationsEnabled },
                                        set: { _ in
                                            Task { await viewModel.toggleNotifications() }
                                        }
                                    ))
                                    .labelsHidden()
                                    .tint(DS.Tokens.Colors.accent)
                                }
                                
                                divider
                                
                                navigationSettingRow(
                                    icon: "clock",
                                    color: DS.Tokens.Colors.accent,
                                    label: "Notification Time",
                                    value: viewModel.notificationTime
                                )
                                
                                divider
                                
                                navigationSettingRow(
                                    icon: "book",
                                    color: DS.Tokens.Colors.tint,
                                    label: "Bible Version",
                                    value: viewModel.bibleVersion
                                )
                            }
                            .background(DS.Tokens.Colors.surface)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DS.Tokens.Colors.border, lineWidth: 0.5))
                        }
                        .padding(.horizontal, 20)

                        // Section: Premium
                        VStack(alignment: .leading, spacing: 10) {
                            sectionTitle("Premium")
                            
                            Button(action: { showingSubscription = true }) {
                                premiumCard
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        
                        // Section: Setup
                        VStack(alignment: .leading, spacing: 10) {
                            sectionTitle("Setup")

                            VStack(spacing: 0) {
                                settingRow(
                                    icon: "gear",
                                    color: DS.Tokens.Colors.accent,
                                    label: "Redo Setup",
                                    description: "Repeat the initial configuration"
                                ) {
                                    Button(action: { showingOnboarding = true }) {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(DS.Tokens.Colors.border)
                                    }
                                }
                            }
                            .background(DS.Tokens.Colors.surface)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DS.Tokens.Colors.border, lineWidth: 0.5))
                        }
                        .padding(.horizontal, 20)

                        // Section: About
                        VStack(alignment: .leading, spacing: 10) {
                            sectionTitle("About")

                            VStack(spacing: 0) {
                                navigationLinkRow(icon: "info.circle", color: DS.Tokens.Colors.olive, label: "About")
                                divider
                                navigationLinkRow(icon: "shield", color: DS.Tokens.Colors.navy, label: "Privacy Policy")
                                divider
                                navigationLinkRow(icon: "doc.text", color: DS.Tokens.Colors.crimson, label: "Terms of Use")
                                divider
                                navigationLinkRow(icon: "envelope", color: DS.Tokens.Colors.tint, label: "Contact Support")
                            }
                            .background(DS.Tokens.Colors.surface)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(DS.Tokens.Colors.border, lineWidth: 0.5))
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Bible Verse Daily v1.0.0")
                            .font(DS.Tokens.Typography.interRegular(size: 13))
                            .foregroundColor(DS.Tokens.Colors.border)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                    .padding(.top, 24)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingSubscription) {
                // Dependency injection for SubscriptionView
                SubscriptionView(viewModel: DependencyContainer.shared.resolveMonetizationViewModel())
            }
            // TODO: Fix OnboardingView visibility and re-enable onboarding sheet
            // .sheet(isPresented: $showingOnboarding) {
            //     // Dependency injection for OnboardingView
            //     OnboardingView(
            //         viewModel: OnboardingViewModel(
            //             updateUserSettingsUseCase: DependencyContainer.shared.updateUserSettingsUseCase
            //         )
            //     ) {
            //         showingOnboarding = false
            //     }
            // }
        }
        .onAppear {
            Task { await viewModel.loadSettings() }
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text.uppercased())
            .font(DS.Tokens.Typography.interMedium(size: 13))
            .foregroundColor(DS.Tokens.Colors.textSecondary)
            .kerning(1)
    }
    
    private var divider: some View {
        Divider().padding(.leading, 60).background(DS.Tokens.Colors.border.opacity(0.3))
    }
    
    private func settingRow<Content: View>(icon: String, color: Color, label: String, description: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 14) {
            ZStack {
                color.opacity(0.15)
                    .frame(width: 36, height: 36)
                    .cornerRadius(10)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(DS.Tokens.Typography.interMedium(size: 16))
                    .foregroundColor(DS.Tokens.Colors.text)
                if let description = description {
                    Text(description)
                        .font(DS.Tokens.Typography.interRegular(size: 13))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                }
            }
            
            Spacer()
            
            content()
        }
        .padding(16)
    }
    
    private func navigationSettingRow(icon: String, color: Color, label: String, value: String) -> some View {
        settingRow(icon: icon, color: color, label: label) {
            HStack(spacing: 8) {
                Text(value)
                    .font(DS.Tokens.Typography.interRegular(size: 14))
                    .foregroundColor(DS.Tokens.Colors.textSecondary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(DS.Tokens.Colors.border)
            }
        }
    }
    
    private func navigationLinkRow(icon: String, color: Color, label: String) -> some View {
        settingRow(icon: icon, color: color, label: label) {
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(DS.Tokens.Colors.border)
        }
    }

    private func canonButton(for canon: Canon) -> some View {
        let isSelected = viewModel.selectedCanon == canon
        return Button(action: {
            Task { await viewModel.updateCanon(canon) }
        }) {
            Text(canon.displayName)
                .font(DS.Tokens.Typography.interRegular(size: 11))
                .foregroundColor(isSelected ? .white : DS.Tokens.Colors.text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isSelected ? DS.Tokens.Colors.accent : DS.Tokens.Colors.border.opacity(0.2))
                .cornerRadius(6)
        }
    }

    private var premiumCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(systemName: "award.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "C5963A"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.isPremium ? "Premium Active" : "Upgrade to Premium")
                        .font(DS.Tokens.Typography.interMedium(size: 17))
                        .foregroundColor(DS.Tokens.Colors.text)
                    Text(viewModel.isPremium ? "Thank you for supporting our mission" : "Unlock all devotionals, remove ads, and more")
                        .font(DS.Tokens.Typography.interRegular(size: 14))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                        .lineLimit(2)
                }
            }
            
            if !viewModel.isPremium {
                Text("View Plans")
                    .font(DS.Tokens.Typography.interMedium(size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(DS.Tokens.Colors.tint)
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(DS.Tokens.Colors.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(DS.Tokens.Colors.accent.opacity(0.4), lineWidth: 1)
        )
    }
}

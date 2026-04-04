import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab = 0
    private let container = DependencyContainer.shared
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: container.resolveHomeViewModel())
                .tabItem {
                    Label("Today", systemImage: "house.fill")
                }
                .tag(0)
            
            BibleView(viewModel: container.resolveBibleViewModel())
                .tabItem {
                    Label("Bible", systemImage: "book.fill")
                }
                .tag(1)
            
            SavedVersesView(viewModel: container.resolveSavedVersesViewModel())
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
                .tag(2)
            
            SettingsView(viewModel: container.resolveSettingsViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(DS.Tokens.Colors.tint)
    }
}

struct PlaceholderView: View {
    let title: String
    
    var body: some View {
        NavigationView {
            VStack {
                Text(title)
                    .font(DS.Tokens.Typography.playfairBold(size: 32))
                    .foregroundColor(DS.Tokens.Colors.text)
                Text("Coming Soon")
                    .font(DS.Tokens.Typography.interMedium(size: 16))
                    .foregroundColor(DS.Tokens.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DS.Tokens.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}


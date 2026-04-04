import SwiftUI

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                    header
                    
                    VerseCardView(verse: viewModel.dailyVerse)
                        .padding(.horizontal, DS.Tokens.Spacing.md)
                    
                    devotionalsSection
                }
                .padding(.vertical, DS.Tokens.Spacing.md)
            }
            .background(DS.Tokens.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
                Text("Good Morning")
                    .font(DS.Tokens.Typography.interMedium(size: 14))
                    .foregroundColor(DS.Tokens.Colors.textSecondary)
                Text("David")
                    .font(DS.Tokens.Typography.playfairBold(size: 28))
                    .foregroundColor(DS.Tokens.Colors.text)
            }
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 20))
                    .foregroundColor(DS.Tokens.Colors.tint)
                    .padding(DS.Tokens.Spacing.sm)
                    .background(DS.Tokens.Colors.surface)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, DS.Tokens.Spacing.md)
    }
    
    private var devotionalsSection: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            Text("Today's Devotionals")
                .font(DS.Tokens.Typography.playfairBold(size: 20))
                .foregroundColor(DS.Tokens.Colors.text)
                .padding(.horizontal, DS.Tokens.Spacing.md)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DS.Tokens.Spacing.md) {
                    ForEach(viewModel.devotionals) { devotional in
                        DevotionalCard(devotional: devotional)
                    }
                }
                .padding(.horizontal, DS.Tokens.Spacing.md)
            }
        }
    }
}

struct DevotionalCard: View {
    let devotional: DevotionalDTO
    
    var body: some View {
        DSCard {
            VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
                DSBadge(devotional.category)
                
                Text(devotional.title)
                    .font(DS.Tokens.Typography.playfairBold(size: 18))
                    .foregroundColor(DS.Tokens.Colors.text)
                    .lineLimit(2)
                
                HStack {
                    Label(devotional.readTime, systemImage: "clock")
                        .font(DS.Tokens.Typography.interMedium(size: 12))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(DS.Tokens.Colors.tint)
                }
            }
        }
        .frame(width: 240, height: 160)
    }
}


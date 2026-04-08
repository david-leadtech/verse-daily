import SwiftUI
import DesignSystem

struct SavedVersesView: View {
    @ObservedObject var viewModel: SavedVersesViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                DS.Tokens.Colors.background.ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.savedVerses.isEmpty {
                    emptyView
                } else {
                    ScrollView {
                        LazyVStack(spacing: DS.Tokens.Spacing.md) {
                            ForEach(viewModel.savedVerses.indices, id: \.self) { index in
                                let verse = viewModel.savedVerses[index]
                                VerseCardView(
                                    verse: verse,
                                    colors: DS.Tokens.Colors.cardGradients[index % DS.Tokens.Colors.cardGradients.count],
                                    onFavoriteToggle: {
                                        Task { await viewModel.toggleFavorite(verse) }
                                    }
                                )
                            }
                        }
                        .padding(DS.Tokens.Spacing.md)
                    }
                }
            }
            .navigationTitle("Saved Verses")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task { await viewModel.loadFavorites() }
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: DS.Tokens.Spacing.md) {
            Image(systemName: "heart.slash")
                .font(.system(size: 48))
                .foregroundColor(DS.Tokens.Colors.border)
            Text("No saved verses yet")
                .font(DS.Tokens.Typography.playfairBold(size: 18))
                .foregroundColor(DS.Tokens.Colors.text)
            Text("Tap the heart icon on any verse to save it here for quick access.")
                .font(DS.Tokens.Typography.interRegular(size: 14))
                .foregroundColor(DS.Tokens.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

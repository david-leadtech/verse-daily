import SwiftUI
import DesignSystem
import CoreModels

struct SavedChapterView: View {
    let bookName: String
    let chapter: Int
    @Binding var isPresented: Bool
    @Environment(\.appTheme) var theme: DesignSystem.AppTheme

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(theme.text)
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 4) {
                        Text(bookName)
                            .font(DS.Tokens.Typography.playfairBold(size: 18))
                            .foregroundColor(theme.text)
                        Text("Chapter \(chapter)")
                            .font(DS.Tokens.Typography.interRegular(size: 12))
                            .foregroundColor(theme.textSecondary)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(theme.accent)
                    }
                }
                .padding(DS.Tokens.Spacing.md)
                .background(theme.surface)
                .border(theme.border, width: 0.5)

                ScrollView {
                    VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                        ForEach(0..<100, id: \.self) { verseNumber in
                            SavedVerseRow(verseNumber: verseNumber + 1, verseText: "En el principio era el Verbo, y el Verbo era con Dios, y el Verbo era Dios.")
                        }
                    }
                    .padding(DS.Tokens.Spacing.lg)
                }
                .background(theme.background)
            }
            .background(theme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct SavedVerseRow: View {
    let verseNumber: Int
    let verseText: String
    @Environment(\.appTheme) var theme: DesignSystem.AppTheme

    var body: some View {
        HStack(alignment: .top, spacing: DS.Tokens.Spacing.md) {
            Text("\(verseNumber)")
                .font(DS.Tokens.Typography.interBold(size: 14))
                .foregroundColor(theme.accent)
                .frame(minWidth: 24)
            Text(verseText)
                .font(DS.Tokens.Typography.interRegular(size: 16))
                .foregroundColor(theme.text)
                .lineSpacing(4)
        }
    }
}

struct SavedVersesView: View {
    @ObservedObject var viewModel: SavedVersesViewModel
    @Environment(\.appTheme) var theme: DesignSystem.AppTheme
    @State private var selectedChapter: (book: String, chapter: Int)?
    @State private var showFullChapter = false

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
                                    },
                                    onReadChapter: {
                                        if let (book, chapter) = parseReference(verse.Reference) {
                                            selectedChapter = (book: book, chapter: chapter)
                                            showFullChapter = true
                                        }
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
            .sheet(isPresented: $showFullChapter) {
                if let selectedChapter = selectedChapter {
                    SavedChapterView(
                        bookName: selectedChapter.book,
                        chapter: selectedChapter.chapter,
                        isPresented: $showFullChapter
                    )
                    .environment(\.appTheme, theme)
                }
            }
        }
        .onAppear {
            Task { await viewModel.loadFavorites() }
        }
    }

    private func parseReference(_ reference: String) -> (book: String, chapter: Int)? {
        let components = reference.split(separator: " ")
        guard components.count >= 2 else { return nil }

        let bookName = String(components[0])
        let chapterString = String(components[1]).split(separator: ":").first.map(String.init) ?? ""

        guard let chapter = Int(chapterString) else { return nil }
        return (book: bookName, chapter: chapter)
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

import SwiftUI
import DesignSystem
import CoreModels

// MARK: - BibleVerseCard (Defined first so VerseListView can use it)
struct BibleVerseCard: View {
    let verse: VerseDTO?
    let colors: [Color]
    let onReadChapter: (() -> Void)?
    @State private var isFavorite: Bool = false

    var body: some View {
        DSCard(colors: colors) {
            if let verse = verse {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                    HStack(alignment: .center, spacing: DS.Tokens.Spacing.md) {
                        DSBadge(verse.Reference)
                            .opacity(0.85)

                        Spacer()

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isFavorite.toggle()
                            }
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? DS.Tokens.Colors.accent : .white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }

                    Text(verse.text)
                        .font(DS.Tokens.Typography.playfairBold(size: 26))
                        .foregroundColor(.white)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)

                    if let onReadChapter = onReadChapter {
                        Button(action: onReadChapter) {
                            HStack(spacing: DS.Tokens.Spacing.sm) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Read Full Chapter")
                                    .font(DS.Tokens.Typography.interBold(size: 14))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(DS.Tokens.Spacing.md)
                            .foregroundColor(colors[0])
                            .background(.white.opacity(0.9))
                            .cornerRadius(10)
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, minHeight: 200)
            }
        }
        .shadow(color: colors[0].opacity(0.4), radius: 20, x: 0, y: 12)
    }
}

// MARK: - VerseListView
struct VerseListView: View {
    @ObservedObject var viewModel: BibleViewModel
    @Environment(\.appTheme) var theme: DesignSystem.AppTheme
    let book: BibleBookDTO
    let chapter: Int
    @State private var showFullChapter = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if viewModel.verses.isEmpty {
                emptyView
            } else {
                ScrollView {
                    LazyVStack(spacing: DS.Tokens.Spacing.md) {
                        ForEach(viewModel.verses.indices, id: \.self) { index in
                            BibleVerseCard(
                                verse: viewModel.verses[index],
                                colors: DS.Tokens.Colors.cardGradients[index % DS.Tokens.Colors.cardGradients.count],
                                onReadChapter: {
                                    showFullChapter = true
                                }
                            )
                        }
                    }
                    .padding(DS.Tokens.Spacing.md)
                }
            }
        }
        .sheet(isPresented: $showFullChapter) {
            FullChapterView(book: book, chapter: chapter, isPresented: $showFullChapter, viewModel: viewModel)
                .environment(\.appTheme, theme)
        }
    }

    private var header: some View {
        HStack {
            Button(action: { viewModel.goBack() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(DS.Tokens.Colors.tint)
            }

            Spacer()

            Text("\(book.name) \(chapter)")
                .font(DS.Tokens.Typography.playfairBold(size: 18))
                .foregroundColor(DS.Tokens.Colors.text)

            Spacer()

            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, DS.Tokens.Spacing.md)
        .padding(.vertical, DS.Tokens.Spacing.sm)
        .background(DS.Tokens.Colors.background)
        .border(DS.Tokens.Colors.border, width: 0.5)
    }

    private var emptyView: some View {
        VStack(spacing: DS.Tokens.Spacing.md) {
            Spacer()
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundColor(DS.Tokens.Colors.border)
            Text("No verses found")
                .font(DS.Tokens.Typography.playfairBold(size: 18))
                .foregroundColor(DS.Tokens.Colors.text)
            Text("This chapter doesn't have any verses in our collection yet.")
                .font(DS.Tokens.Typography.interRegular(size: 14))
                .foregroundColor(DS.Tokens.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

// MARK: - FullChapterView
struct FullChapterView: View {
    let book: BibleBookDTO
    let chapter: Int
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: BibleViewModel
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
                        Text(book.name)
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

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else if viewModel.verses.isEmpty {
                    VStack(spacing: DS.Tokens.Spacing.lg) {
                        Spacer()
                        Image(systemName: "book")
                            .font(.system(size: 48))
                            .foregroundColor(theme.textSecondary)
                        Text("No verses found")
                            .font(DS.Tokens.Typography.playfairBold(size: 18))
                            .foregroundColor(theme.text)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                            ForEach(viewModel.verses.indices, id: \.self) { index in
                                BibleVerseRow(
                                    verse: viewModel.verses[index]
                                )
                            }
                        }
                        .padding(DS.Tokens.Spacing.lg)
                    }
                    .background(theme.background)
                }
            }
            .background(theme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

struct BibleVerseRow: View {
    let verse: VerseDTO
    @Environment(\.appTheme) var theme: DesignSystem.AppTheme

    var body: some View {
        HStack(alignment: .top, spacing: DS.Tokens.Spacing.md) {
            if let verseNum = extractVerseNumber(from: verse.Reference) {
                Text("\(verseNum)")
                    .font(DS.Tokens.Typography.interBold(size: 14))
                    .foregroundColor(theme.accent)
                    .frame(minWidth: 24)
            }
            Text(verse.text)
                .font(DS.Tokens.Typography.interRegular(size: 16))
                .foregroundColor(theme.text)
                .lineSpacing(4)
        }
    }

    private func extractVerseNumber(from reference: String) -> Int? {
        let components = reference.split(separator: ":")
        return components.count > 1 ? Int(components[1]) : nil
    }
}

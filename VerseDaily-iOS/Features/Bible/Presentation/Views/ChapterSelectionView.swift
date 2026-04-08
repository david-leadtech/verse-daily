import SwiftUI
import DesignSystem

struct ChapterSelectionView: View {
    @ObservedObject var viewModel: BibleViewModel
    let book: BibleBookDTO
    @State private var selectedRange: ChapterRange?

    private var chapters: [Int] {
        Array(1...book.chapters)
    }

    private var chapterRanges: [ChapterRange] {
        let chapterCount = book.chapters
        var ranges: [ChapterRange] = []
        let rangeSize = 10

        for start in stride(from: 1, through: chapterCount, by: rangeSize) {
            let end = min(start + rangeSize - 1, chapterCount)
            ranges.append(ChapterRange(start: start, end: end))
        }

        return ranges
    }

    private let gridColumns = [
        GridItem(.adaptive(minimum: 56, maximum: 56), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerView

            // Range Selector (Scroll horizontal)
            rangeScrollView

            // Chapter Grid (Expandable)
            if let range = selectedRange {
                chapterGridView(for: range)
            } else {
                emptyStateView
            }

            Spacer()
        }
        .background(DS.Tokens.Colors.background)
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
            HStack(spacing: DS.Tokens.Spacing.md) {
                Button(action: { viewModel.goBack() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(DS.Tokens.Colors.tint)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(book.name)
                        .font(DS.Tokens.Typography.playfairBold(size: 28))
                        .foregroundColor(DS.Tokens.Colors.text)
                    Text("\(book.chapters) chapters")
                        .font(DS.Tokens.Typography.interRegular(size: 14))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                }

                Spacer()
            }
            .padding(DS.Tokens.Spacing.lg)
        }
        .background(DS.Tokens.Colors.surface)
    }

    private var rangeScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.Tokens.Spacing.sm) {
                ForEach(chapterRanges, id: \.self) { range in
                    rangeButton(for: range)
                }
            }
            .padding(.horizontal, DS.Tokens.Spacing.lg)
            .padding(.vertical, DS.Tokens.Spacing.md)
        }
        .background(DS.Tokens.Colors.background)
    }

    private func rangeButton(for range: ChapterRange) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedRange = range
            }
        }) {
            VStack(spacing: 4) {
                Text("\(range.start)–\(range.end)")
                    .font(DS.Tokens.Typography.interBold(size: 14))
                Text("(\(range.end - range.start + 1))")
                    .font(DS.Tokens.Typography.interRegular(size: 12))
            }
            .frame(minWidth: 70)
            .padding(.vertical, DS.Tokens.Spacing.sm)
            .padding(.horizontal, DS.Tokens.Spacing.md)
            .foregroundColor(selectedRange == range ? DS.Tokens.Colors.background : DS.Tokens.Colors.text)
            .background(selectedRange == range ? DS.Tokens.Colors.accent : DS.Tokens.Colors.surface)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        selectedRange == range ? Color.clear : DS.Tokens.Colors.border,
                        lineWidth: 1
                    )
            )
        }
    }

    private func chapterGridView(for range: ChapterRange) -> some View {
        let rangeChapters = Array(range.start...range.end)

        return VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: DS.Tokens.Spacing.md) {
                    ForEach(rangeChapters, id: \.self) { chapter in
                        chapterButton(for: chapter)
                    }
                }
                .padding(DS.Tokens.Spacing.lg)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }

    private func chapterButton(for chapter: Int) -> some View {
        Button(action: {
            Task {
                await viewModel.selectChapter(chapter, in: book)
            }
        }) {
            Text("\(chapter)")
                .font(DS.Tokens.Typography.playfairBold(size: 20))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .foregroundColor(DS.Tokens.Colors.background)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DS.Tokens.Colors.tint,
                            DS.Tokens.Colors.accent
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(DS.Tokens.Colors.border, lineWidth: 0.5)
                )
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: DS.Tokens.Spacing.lg) {
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundColor(DS.Tokens.Colors.textSecondary)

            Text("Select a range above")
                .font(DS.Tokens.Typography.interRegular(size: 16))
                .foregroundColor(DS.Tokens.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DS.Tokens.Spacing.xxl)
    }
}

// MARK: - Supporting Types

struct ChapterRange: Identifiable, Hashable {
    let start: Int
    let end: Int

    var id: String { "\(start)-\(end)" }
}

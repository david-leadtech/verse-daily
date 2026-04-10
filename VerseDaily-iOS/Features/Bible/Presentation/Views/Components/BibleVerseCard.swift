import SwiftUI
import DesignSystem
import CoreModels

struct BibleVerseCard: View {
    let verse: VerseDTO?
    let colors: [Color]
    let onReadChapter: (() -> Void)?
    @State private var isFavorite: Bool = false

    var body: some View {
        DSCard(colors: colors) {
            if let verse = verse {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                    // Header with reference
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

                    // Verse text
                    Text(verse.text)
                        .font(DS.Tokens.Typography.playfairBold(size: 26))
                        .foregroundColor(.white)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)

                    // Read Full Chapter button
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

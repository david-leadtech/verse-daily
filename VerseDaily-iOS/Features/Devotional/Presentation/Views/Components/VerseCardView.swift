import SwiftUI
import DesignSystem

public struct VerseCardView: View {
    let verse: VerseDTO?
    let colors: [Color]
    let onFavoriteToggle: (() -> Void)?
    let onReadChapter: (() -> Void)?
    @State private var isFavorite: Bool = false

    public init(
        verse: VerseDTO?,
        colors: [Color] = DS.Tokens.Colors.cardGradients[0],
        onFavoriteToggle: (() -> Void)? = nil,
        onReadChapter: (() -> Void)? = nil
    ) {
        self.verse = verse
        self.colors = colors
        self.onFavoriteToggle = onFavoriteToggle
        self.onReadChapter = onReadChapter
    }

    public var body: some View {
        DSCard(colors: colors) {
            if let verse = verse {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                    // Header with reference and actions
                    HStack(alignment: .center, spacing: DS.Tokens.Spacing.md) {
                        DSBadge(verse.Reference)
                            .opacity(0.85)

                        Spacer()

                        HStack(spacing: DS.Tokens.Spacing.md) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isFavorite.toggle()
                                }
                                onFavoriteToggle?()
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? DS.Tokens.Colors.accent : .white)
                                    .font(.system(size: 18, weight: .semibold))
                            }

                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                            }
                        }
                    }

                    // Verse text
                    Text(verse.text)
                        .font(DS.Tokens.Typography.playfairBold(size: 26))
                        .foregroundColor(.white)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)

                    // Divider
                    Divider()
                        .opacity(0.3)

                    // Reflection
                    if let reflection = verse.reflection {
                        Text(reflection)
                            .font(DS.Tokens.Typography.interRegular(size: 14))
                            .foregroundColor(.white.opacity(0.95))
                            .lineSpacing(5)
                    }

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


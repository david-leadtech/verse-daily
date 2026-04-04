import SwiftUI

public struct VerseCardView: View {
    let verse: VerseDTO?
    let colors: [Color]
    let onFavoriteToggle: (() -> Void)?
    @State private var isFavorite: Bool = false
    
    public init(verse: VerseDTO?, colors: [Color] = DS.Tokens.Colors.cardGradients[0], onFavoriteToggle: (() -> Void)? = nil) {
        self.verse = verse
        self.colors = colors
        self.onFavoriteToggle = onFavoriteToggle
    }
    
    public var body: some View {
        DSCard(colors: colors) {
            if let verse = verse {
                HStack(spacing: DS.Tokens.Spacing.md) {
                    DSBadge(verse.Reference)
                        .opacity(0.8)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {
                            isFavorite.toggle()
                            onFavoriteToggle?()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? DS.Tokens.Colors.accent : .white)
                                .font(.system(size: 20))
                        }
                        
                        Button(action: {
                            // Share logic
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                }
                
                Text(verse.text)
                    .font(DS.Tokens.Typography.playfairBold(size: 24))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                
                if let reflection = verse.reflection {
                    Text(reflection)
                        .font(DS.Tokens.Typography.interRegular(size: 15))
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(6)
                        .padding(.top, DS.Tokens.Spacing.sm)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, minHeight: 200)
            }
        }
        .shadow(color: colors[0].opacity(0.3), radius: 15, x: 0, y: 10)
    }
}


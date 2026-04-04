import SwiftUI

public struct DSCard<Content: View>: View {
    let content: Content
    let colors: [Color]?
    
    public init(colors: [Color]? = nil, @ViewBuilder content: () -> Content) {
        self.colors = colors
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            content
        }
        .padding(DS.Tokens.Spacing.lg)
        .background(
            ZStack {
                if let colors = colors {
                    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                } else {
                    DS.Tokens.Colors.surface
                }
            }
        )
        .cornerRadius(24)
        .shadow(color: shadowColor(), radius: 10, x: 0, y: 5)
    }
    
    private func shadowColor() -> Color {
        if let colors = colors {
            return colors[0].opacity(0.2)
        }
        return Color.black.opacity(0.03)
    }
}

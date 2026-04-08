import SwiftUI

public enum DSBadgeStyle: Sendable {
    case `default`
    case success
    case warning
    case danger
}

public struct DSBadge: View {
    let text: String
    let style: DSBadgeStyle
    
    public init(_ text: String, style: DSBadgeStyle = .default) {
        self.text = text
        self.style = style
    }
    
    public var body: some View {
        Text(text)
            .font(DS.Tokens.Typography.interBold(size: 10))
            .padding(.horizontal, DS.Tokens.Spacing.sm)
            .padding(.vertical, DS.Tokens.Spacing.xs)
            .background(backgroundColor().opacity(0.1))
            .foregroundColor(backgroundColor())
            .cornerRadius(6)
    }
    
    private func backgroundColor() -> Color {
        switch style {
        case .default: return DS.Tokens.Colors.accent
        case .success: return DS.Tokens.Colors.success
        case .warning: return DS.Tokens.Colors.warning
        case .danger: return DS.Tokens.Colors.danger
        }
    }
}

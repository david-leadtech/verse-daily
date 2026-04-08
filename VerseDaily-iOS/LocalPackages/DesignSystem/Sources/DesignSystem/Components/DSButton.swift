import SwiftUI

public enum DSButtonStyle: Sendable {
    case primary
    case secondary
    case ghost
}

public struct DSButton: View {
    let title: String
    let style: DSButtonStyle
    let action: () -> Void
    
    public init(_ title: String, style: DSButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(DS.Tokens.Typography.interBold(size: 16))
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Tokens.Spacing.md)
        }
        .buttonStyle(DSButtonStyleModifier(style: style))
    }
}

struct DSButtonStyleModifier: ButtonStyle {
    let style: DSButtonStyle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor(for: configuration.isPressed))
            .foregroundColor(foregroundColor())
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor(), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
    
    private func backgroundColor(for pressed: Bool) -> Color {
        switch style {
        case .primary: return DS.Tokens.Colors.tint
        case .secondary: return DS.Tokens.Colors.surface
        case .ghost: return .clear
        }
    }
    
    private func foregroundColor() -> Color {
        switch style {
        case .primary: return .white
        case .secondary: return DS.Tokens.Colors.tint
        case .ghost: return DS.Tokens.Colors.tint
        }
    }
    
    private func borderColor() -> Color {
        switch style {
        case .primary: return .clear
        case .secondary: return DS.Tokens.Colors.border
        case .ghost: return .clear
        }
    }
}

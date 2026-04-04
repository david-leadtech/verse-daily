import SwiftUI

public struct DSInput: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    
    public init(_ label: String, text: Binding<String>, placeholder: String = "") {
        self.label = label
        self._text = text
        self.placeholder = placeholder
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
            Text(label)
                .font(DS.Tokens.Typography.interBold(size: 14))
                .foregroundColor(DS.Tokens.Colors.textSecondary)
            
            TextField(placeholder, text: $text)
                .padding(DS.Tokens.Spacing.md)
                .background(DS.Tokens.Colors.surface)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(DS.Tokens.Colors.border, lineWidth: 1)
                )
                .font(DS.Tokens.Typography.interRegular(size: 16))
        }
    }
}

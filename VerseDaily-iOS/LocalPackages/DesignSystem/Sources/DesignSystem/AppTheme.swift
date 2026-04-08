import SwiftUI

public struct AppTheme: Equatable {
    public let text: Color
    public let textSecondary: Color
    public let background: Color
    public let surface: Color
    public let accent: Color
    public let tint: Color
    public let border: Color
    public let parchment: Color
    public let cardGradients: [[Color]]
    
    public init(
        text: Color = Color(hex: "#2C1810"),
        textSecondary: Color = Color(hex: "#7A6B5D"),
        background: Color = Color(hex: "#FDF8F0"),
        surface: Color = Color(hex: "#FFFCF5"),
        accent: Color = Color(hex: "#C5963A"),
        tint: Color = Color(hex: "#8B4513"),
        border: Color = Color(hex: "#E8DFD0"),
        parchment: Color = Color(hex: "#F5ECD7"),
        cardGradients: [[Color]] = [
            [Color(hex: "#8B4513"), Color(hex: "#5C2D0E")],
            [Color(hex: "#1E3A5F"), Color(hex: "#0F2036")],
            [Color(hex: "#5B7D3A"), Color(hex: "#3D5426")],
            [Color(hex: "#8B2252"), Color(hex: "#5E1737")]
        ]
    ) {
        self.text = text
        self.textSecondary = textSecondary
        self.background = background
        self.surface = surface
        self.accent = accent
        self.tint = tint
        self.border = border
        self.parchment = parchment
        self.cardGradients = cardGradients
    }
}

public extension AppTheme {
    /// Factory method to construct a theme based on liturgical color
    static func liturgical(_ color: LiturgicalColor) -> AppTheme {
        switch color {
        case .violet:
            return AppTheme(
                accent: Color(hex: "#7851A9"), // Royal Purple
                tint: Color(hex: "#4B0082"), // Indigo
                cardGradients: [
                    [Color(hex: "#4B0082"), Color(hex: "#300052")], // Deep violet
                    [Color(hex: "#5C2D0E"), Color(hex: "#3A1A06")], // Brown fallback
                ]
            )
        case .green:
            return AppTheme(
                accent: Color(hex: "#4C8C4A"), // Ordinary Time Green
                tint: Color(hex: "#2E592D"), 
                cardGradients: [
                    [Color(hex: "#2E592D"), Color(hex: "#1A3319")], // Deep green
                    [Color(hex: "#5C2D0E"), Color(hex: "#3A1A06")],
                ]
            )
        case .white:
            return AppTheme(
                accent: Color(hex: "#D4AF37"), // Gold accent for white/festive
                tint: Color(hex: "#C5963A"),
                cardGradients: [
                    [Color(hex: "#E8DFD0"), Color(hex: "#D3C4A3")], // White/Gold
                    [Color(hex: "#8B4513"), Color(hex: "#5C2D0E")],
                ]
            )
        case .red:
            return AppTheme(
                accent: Color(hex: "#B22222"), // Martyr Red
                tint: Color(hex: "#8B0000"),
                cardGradients: [
                    [Color(hex: "#8B0000"), Color(hex: "#4D0000")], // Deep red
                    [Color(hex: "#5C2D0E"), Color(hex: "#3A1A06")],
                ]
            )
        }
    }
    
    static let standard = AppTheme()
}

// MARK: - Environment Support

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .standard
}

public extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

// MARK: - Color Hex Extension

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

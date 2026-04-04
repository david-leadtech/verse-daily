import SwiftUI

public enum AppTheme {
    public enum Colors {
        public static let text = Color(hex: "#2C1810")
        public static let textSecondary = Color(hex: "#7A6B5D")
        public static let background = Color(hex: "#FDF8F0")
        public static let surface = Color(hex: "#FFFCF5")
        public static let accent = Color(hex: "#C5963A")
        public static let tint = Color(hex: "#8B4513")
        public static let border = Color(hex: "#E8DFD0")
        public static let parchment = Color(hex: "#F5ECD7")
        
        public static let cardGradients: [[Color]] = [
            [Color(hex: "#8B4513"), Color(hex: "#5C2D0E")],
            [Color(hex: "#1E3A5F"), Color(hex: "#0F2036")],
            [Color(hex: "#5B7D3A"), Color(hex: "#3D5426")],
            [Color(hex: "#8B2252"), Color(hex: "#5E1737")]
        ]
    }
}

extension Color {
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

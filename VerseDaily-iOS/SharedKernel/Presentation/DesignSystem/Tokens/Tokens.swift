import SwiftUI

public enum DS {
    public enum Tokens {
        public enum Colors {
            public static let text = Color(hex: "#2C1810")
            public static let textSecondary = Color(hex: "#7A6B5D")
            public static let background = Color(hex: "#FDF8F0")
            public static let surface = Color(hex: "#FFFCF5")
            public static let accent = Color(hex: "#C5963A")
            public static let tint = Color(hex: "#8B4513")
            public static let border = Color(hex: "#E8DFD0")
            public static let parchment = Color(hex: "#F5ECD7")
            
            public static let success = Color(hex: "#5B7D3A")
            public static let warning = Color(hex: "#E8D5A3") // Accent light as warning for now
            public static let danger = Color(hex: "#B54040")
        }
        
        public enum Spacing {
            public static let xs: CGFloat = 4
            public static let sm: CGFloat = 8
            public static let md: CGFloat = 16
            public static let lg: CGFloat = 24
            public static let xl: CGFloat = 32
            public static let xxl: CGFloat = 48
        }
        
        public enum Typography {
            public static func playfairBold(size: CGFloat) -> Font {
                .custom("PlayfairDisplay-Bold", size: size)
            }
            public static func interMedium(size: CGFloat) -> Font {
                .custom("Inter-Medium", size: size)
            }
            public static func interBold(size: CGFloat) -> Font {
                .custom("Inter-Bold", size: size)
            }
            public static func interRegular(size: CGFloat) -> Font {
                .custom("Inter-Regular", size: size)
            }
        }
    }
}

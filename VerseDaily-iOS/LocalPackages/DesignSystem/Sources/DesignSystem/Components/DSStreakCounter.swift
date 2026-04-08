import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
public struct DSStreakCounter: View {
    public let count: Int
    public let accentColor: Color
    
    public init(count: Int, accentColor: Color = .orange) {
        self.count = count
        self.accentColor = accentColor
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .foregroundColor(count > 0 ? accentColor : .gray.opacity(0.3))
                .font(.system(size: 16, weight: .bold))
            
            Text("\(count)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(count > 0 ? .primary : .secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(count > 0 ? accentColor.opacity(0.1) : Color.gray.opacity(0.1))
        )
    }
}

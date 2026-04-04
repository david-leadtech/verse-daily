import SwiftUI

public struct DSTable<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    
    public init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        List(data) { item in
            content(item)
                .listRowBackground(DS.Tokens.Colors.surface)
                .listRowSeparatorTint(DS.Tokens.Colors.border)
        }
        .listStyle(PlainListStyle())
        .background(DS.Tokens.Colors.background)
    }
}

import SwiftUI

public struct DSModalModifier: ViewModifier {
    let title: String
    @Binding var isPresented: Bool
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    content
                        .navigationTitle(title)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    isPresented = false
                                }
                                .foregroundColor(DS.Tokens.Colors.tint)
                            }
                        }
                }
            }
    }
}

extension View {
    public func dsModal(title: String, isPresented: Binding<Bool>) -> some View {
        self.modifier(DSModalModifier(title: title, isPresented: isPresented))
    }
}

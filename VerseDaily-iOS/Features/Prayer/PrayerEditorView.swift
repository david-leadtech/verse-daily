import SwiftUI
import DesignSystem
import CoreModels
import CoreServices

public struct PrayerEditorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PrayerJournalViewModel
    @Environment(\.appTheme) var theme: AppTheme
    @EnvironmentObject var liturgicalViewModel: LiturgicalViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    @FocusState private var isFocused: Bool
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
                        
                        TextField("Título", text: $title)
                            .font(DS.Tokens.Typography.playfairBold(size: 24))
                            .foregroundColor(theme.text)
                            .padding(.top)
                        
                        Divider()
                        
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Comparte lo que Dios pone en tu corazón...")
                                    .font(DS.Tokens.Typography.interRegular(size: 16))
                                    .foregroundColor(theme.textSecondary.opacity(0.5))
                                    .padding(.top, 8)
                            }
                            
                            TextEditor(text: $content)
                                .font(DS.Tokens.Typography.interRegular(size: 16))
                                .foregroundColor(theme.text)
                                .scrollContentBackground(.hidden)
                                .focused($isFocused)
                                .frame(minHeight: 300)
                        }
                    }
                    .padding()
                }
                
                // Toolbar (optional)
                HStack {
                    if let day = liturgicalViewModel.day {
                         liturgicalIndicator(day: day)
                    }
                    Spacer()
                    Button {
                        isFocused = false
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .foregroundColor(theme.accent)
                    }
                }
                .padding()
                .background(theme.surface)
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Nueva Oración")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(theme.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveAndDismiss()
                    }
                    .font(.headline)
                    .foregroundColor(theme.accent)
                    .disabled(content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func liturgicalIndicator(day: LiturgicalDay) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(hex: liturgicalColorHex))
                .frame(width: 10, height: 10)
            
            Text(day.season)
                .font(DS.Tokens.Typography.interBold(size: 12))
                .foregroundColor(theme.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(theme.background)
        .clipShape(Capsule())
    }
    
    private var liturgicalColorHex: String {
        guard let day = liturgicalViewModel.day else { return "#FFFFFF" }
        // Map common names to hex for persistence
        let lColor = LiturgicalColor(string: day.celebrations.first?.colour ?? "green")
        switch lColor {
        case .green: return "#4C8C4A"
        case .violet: return "#7851A9"
        case .white: return "#D4AF37"
        case .red: return "#B22222"
        }
    }
    
    private func saveAndDismiss() {
        viewModel.addEntry(
            title: title,
            content: content,
            liturgicalColor: liturgicalColorHex,
            verseReference: nil // Could be linked to current daily verse
        )
        dismiss()
    }
}

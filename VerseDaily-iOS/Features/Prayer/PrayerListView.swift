import SwiftUI
import DesignSystem
import CoreModels
import CoreServices

public struct PrayerListView: View {
    @EnvironmentObject var viewModel: PrayerJournalViewModel
    @Environment(\.appTheme) var theme: AppTheme
    @State private var showingEditor = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                
                if viewModel.entries.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(viewModel.entries) { entry in
                            PrayerEntryRow(entry: entry)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .padding(.vertical, 4)
                        }
                        .onDelete(perform: viewModel.deleteEntry)
                    }
                    .listStyle(PlainListStyle())
                }
                
                addButton
            }
            .navigationTitle("Mi Diario")
            .sheet(isPresented: $showingEditor) {
                PrayerEditorView()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: DS.Tokens.Spacing.md) {
            Image(systemName: "pencil.and.outline")
                .font(.system(size: 60))
                .foregroundColor(theme.accent.opacity(0.5))
            
            Text("Comienza tu diario")
                .font(DS.Tokens.Typography.playfairBold(size: 24))
                .foregroundColor(theme.text)
            
            Text("Escribe tus reflexiones, oraciones y lo que Dios pone en tu corazón hoy.")
                .font(DS.Tokens.Typography.interRegular(size: 16))
                .foregroundColor(theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showingEditor = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(theme.accent)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding(30)
            }
        }
    }
}

struct PrayerEntryRow: View {
    let entry: PrayerEntry
    @Environment(\.appTheme) var theme: AppTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
            HStack {
                Text(entry.date, style: .date)
                    .font(DS.Tokens.Typography.interBold(size: 12))
                    .foregroundColor(theme.accent)
                
                Spacer()
                
                Circle()
                    .fill(Color(hex: entry.liturgicalColor))
                    .frame(width: 8, height: 8)
            }
            
            if !entry.title.isEmpty {
                Text(entry.title)
                    .font(DS.Tokens.Typography.playfairBold(size: 18))
                    .foregroundColor(theme.text)
            }
            
            Text(entry.content)
                .font(DS.Tokens.Typography.interRegular(size: 14))
                .foregroundColor(theme.textSecondary)
                .lineLimit(3)
            
            if let ref = entry.verseReference {
                Text(ref)
                    .font(DS.Tokens.Typography.interMedium(size: 12))
                    .italic()
                    .foregroundColor(theme.accent.opacity(0.8))
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(theme.surface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

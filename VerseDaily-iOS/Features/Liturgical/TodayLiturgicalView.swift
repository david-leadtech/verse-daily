import SwiftUI
import DesignSystem
import CoreModels
import CoreServices

public struct TodayLiturgicalView: View {
    @EnvironmentObject var viewModel: LiturgicalViewModel
    @EnvironmentObject var streakViewModel: StreakViewModel
    @Environment(\.appTheme) var theme: AppTheme
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.lg) {
                    headerSection
                    
                    if let day = viewModel.day {
                        infoCard(day: day)
                        celebrationsList(day: day)
                    } else if let error = viewModel.errorMessage {
                        errorView(error)
                    } else {
                        loadingView
                    }
                }
                .padding()
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("Liturgia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await viewModel.loadToday() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(theme.accent)
                    }
                }
            }
        }
    }
    
    // MARK: - Components
    
    private var headerSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
                Text("CALENDARIO LITÚRGICO")
                    .font(DS.Tokens.Typography.interBold(size: 12))
                    .foregroundColor(theme.accent)
                    .tracking(2)
                
                Text(currentDateString)
                    .font(DS.Tokens.Typography.playfairBold(size: 28))
                    .foregroundColor(theme.text)
            }
            
            Spacer()
            
            DSStreakCounter(count: streakViewModel.currentStreak, accentColor: theme.accent)
                .padding(.bottom, 4)
        }
    }
    
    private func infoCard(day: LiturgicalDay) -> some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
            HStack {
                Circle()
                    .fill(liturgicalColor)
                    .frame(width: 12, height: 12)
                
                Text(day.season.uppercased())
                    .font(DS.Tokens.Typography.interBold(size: 14))
                    .foregroundColor(theme.textSecondary)
            }
            
            Text("Hoy nos encontramos en \(day.season).")
                .font(DS.Tokens.Typography.interMedium(size: 16))
                .foregroundColor(theme.text)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func celebrationsList(day: LiturgicalDay) -> some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            Text("Celebraciones")
                .font(DS.Tokens.Typography.playfairBold(size: 20))
                .foregroundColor(theme.text)
            
            DSTable(day.celebrations) { celebration in
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
                    Text(celebration.title)
                        .font(DS.Tokens.Typography.interBold(size: 16))
                        .foregroundColor(theme.text)
                    
                    Text(celebration.rank)
                        .font(DS.Tokens.Typography.interRegular(size: 14))
                        .foregroundColor(theme.textSecondary)
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .tint(theme.accent)
            Text("Cargando calendario...")
                .font(DS.Tokens.Typography.interMedium(size: 14))
                .foregroundColor(theme.textSecondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: DS.Tokens.Spacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 44))
                .foregroundColor(.orange)
            
            Text("No se pudo cargar la información")
                .font(DS.Tokens.Typography.interBold(size: 18))
            
            Text(message)
                .font(DS.Tokens.Typography.interRegular(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(theme.textSecondary)
            
            Button("Reintentar") {
                Task { await viewModel.loadToday() }
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accent)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300)
    }
    
    // MARK: - Helpers
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: Date()).capitalized
    }
    
    private var liturgicalColor: Color {
        guard let day = viewModel.day else { return .gray }
        let lColor = LiturgicalColor(string: day.celebrations.first?.colour ?? "green")
        switch lColor {
        case .green: return .green
        case .violet: return .purple
        case .white: return .yellow
        case .red: return .red
        }
    }
}

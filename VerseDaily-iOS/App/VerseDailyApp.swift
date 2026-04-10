import SwiftUI
import SwiftData
import CoreModels
import CoreServices
import DesignSystem

@main
struct VerseDailyApp: App {
    @StateObject private var liturgicalVM = LiturgicalViewModel()
    @StateObject private var prayerVM = PrayerJournalViewModel()
    @StateObject private var streakVM = StreakViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(liturgicalVM)
                .environmentObject(prayerVM)
                .environmentObject(streakVM)
                .environment(\.appTheme, liturgicalVM.theme)
                .task {
                    await liturgicalVM.loadToday()
                    streakVM.recordActivity()
                }
                .modelContainer(for: [PrayerEntry.self])
        }
    }

}


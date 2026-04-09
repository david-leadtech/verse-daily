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
    @StateObject private var revenueCatVM = RevenueCatManager.shared
    @StateObject private var onboardingVM: OnboardingViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        let container = DependencyContainer.shared
        _onboardingVM = StateObject(
            wrappedValue: OnboardingViewModel(
                userRepository: container.userRepository,
                completeOnboardingUseCase: container.completeOnboardingUseCase
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(liturgicalVM)
                    .environmentObject(prayerVM)
                    .environmentObject(streakVM)
                    .environment(\.appTheme, liturgicalVM.theme)
                    .task {
                        // Initialize RevenueCat for monetization
                        await RevenueCatManager.shared.initialize()

                        // Load other app data
                        await liturgicalVM.loadToday()
                        streakVM.recordActivity()
                    }
                    .onChange(of: revenueCatVM.customerInfo) { oldValue, newValue in
                        // Sync premium status when customer info changes
                        Task {
                            let settingsVM = DependencyContainer.shared.resolveSettingsViewModel()
                            let isPremium = newValue?.entitlements.active["Verse Daily Pro"] != nil
                            await settingsVM.syncPremiumStatus(isPremium)
                        }
                    }
                    .modelContainer(for: [PrayerEntry.self])
            } else {
                OnboardingView(viewModel: onboardingVM) {
                    hasCompletedOnboarding = true
                }
            }
        }
    }

}


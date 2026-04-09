import Foundation
import Combine

@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public var notificationsEnabled: Bool = false
    @Published public var notificationTime: String = "08:00 AM"
    @Published public var bibleVersion: String = "KJV"
    @Published public var isPremium: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var error: LocalizedError?

    private let getUserSettingsUseCase: GetUserSettingsUseCase
    private let updateUserSettingsUseCase: UpdateUserSettingsUseCase

    public init(getUserSettingsUseCase: GetUserSettingsUseCase, updateUserSettingsUseCase: UpdateUserSettingsUseCase) {
        self.getUserSettingsUseCase = getUserSettingsUseCase
        self.updateUserSettingsUseCase = updateUserSettingsUseCase
    }

    public func loadSettings() async {
        isLoading = true
        error = nil
        do {
            let settings = try await getUserSettingsUseCase.execute()
            self.notificationsEnabled = settings.notificationsEnabled
            self.notificationTime = settings.notificationTime
            self.bibleVersion = settings.bibleVersion
            self.isPremium = settings.isPremium
        } catch let err as LocalizedError {
            self.error = err
        } catch {
            print("Error loading settings: \(error)")
        }
        isLoading = false
    }
    
    public func toggleNotifications() async {
        notificationsEnabled.toggle()
        await saveSettings()
    }

    /// Sync premium status from RevenueCat
    /// Called when subscription status changes
    public func syncPremiumStatus(_ isPremiumNow: Bool) async {
        guard isPremium != isPremiumNow else { return }

        self.isPremium = isPremiumNow
        await saveSettings()
    }

    private func saveSettings() async {
        error = nil
        do {
            try await updateUserSettingsUseCase.execute(
                notificationsEnabled: notificationsEnabled,
                notificationTime: notificationTime,
                bibleVersion: bibleVersion,
                isPremium: isPremium
            )
        } catch let err as LocalizedError {
            self.error = err
        } catch {
            print("Error saving settings: \(error)")
        }
    }
}

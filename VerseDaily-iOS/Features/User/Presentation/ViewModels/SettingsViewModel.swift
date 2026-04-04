import Foundation
import Combine

@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public var notificationsEnabled: Bool = false
    @Published public var notificationTime: String = "08:00 AM"
    @Published public var bibleVersion: String = "KJV"
    @Published public var isPremium: Bool = false
    @Published public var isLoading: Bool = false
    
    private let getUserSettingsUseCase: GetUserSettingsUseCase
    private let updateUserSettingsUseCase: UpdateUserSettingsUseCase
    
    public init(getUserSettingsUseCase: GetUserSettingsUseCase, updateUserSettingsUseCase: UpdateUserSettingsUseCase) {
        self.getUserSettingsUseCase = getUserSettingsUseCase
        self.updateUserSettingsUseCase = updateUserSettingsUseCase
    }
    
    public func loadSettings() async {
        isLoading = true
        do {
            let settings = try await getUserSettingsUseCase.execute()
            self.notificationsEnabled = settings.notificationsEnabled
            self.notificationTime = settings.notificationTime
            self.bibleVersion = settings.bibleVersion
            self.isPremium = settings.isPremium
        } catch {
            print("Error loading settings: \(error)")
        }
        isLoading = false
    }
    
    public func toggleNotifications() async {
        notificationsEnabled.toggle()
        await saveSettings()
    }
    
    private func saveSettings() async {
        do {
            let settings = UserSettings(
                notificationsEnabled: notificationsEnabled,
                notificationTime: notificationTime,
                bibleVersion: bibleVersion,
                isPremium: isPremium
            )
            try await updateUserSettingsUseCase.execute(settings: settings)
        } catch {
            print("Error saving settings: \(error)")
        }
    }
}

import Foundation
import Combine
import CoreModels

@MainActor
public final class SettingsViewModel: ObservableObject {
    // Profile
    @Published public var userName: String = ""
    @Published public var userEmail: String = ""

    // Preferences
    @Published public var notificationsEnabled: Bool = false
    @Published public var notificationTime: String = "08:00 AM"
    @Published public var bibleVersion: String = "KJV"
    @Published public var isPremium: Bool = false

    // Bible Settings
    @Published public var selectedCanon: Canon = .protestant
    @Published public var showAdditionalBooks: Bool = false
    @Published public var readingPreferences: Set<ReadingPreference> = []

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
            // Profile
            self.userName = settings.userName ?? ""
            self.userEmail = settings.userEmail ?? ""
            // Preferences
            self.notificationsEnabled = settings.notificationsEnabled
            self.notificationTime = settings.notificationTime
            self.bibleVersion = settings.bibleVersion
            self.isPremium = settings.isPremium
            // Bible Settings
            self.selectedCanon = settings.canon
            self.showAdditionalBooks = settings.showAdditionalBooks
            self.readingPreferences = Set(settings.readingPreferences ?? [])
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

    public func updateCanon(_ canon: Canon) async {
        selectedCanon = canon
        await saveSettings()
    }

    public func toggleAdditionalBooks() async {
        showAdditionalBooks.toggle()
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
                isPremium: isPremium,
                canon: selectedCanon,
                showAdditionalBooks: showAdditionalBooks
            )
        } catch let err as LocalizedError {
            self.error = err
        } catch {
            print("Error saving settings: \(error)")
        }
    }

    public func updateReadingPreference(_ preference: ReadingPreference) {
        if readingPreferences.contains(preference) {
            readingPreferences.remove(preference)
        } else {
            readingPreferences.insert(preference)
        }
        Task { await saveSettings() }
    }
}

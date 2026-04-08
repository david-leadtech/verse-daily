import SwiftUI
import CoreModels
import CoreServices
import DesignSystem

@MainActor
public final class StreakViewModel: ObservableObject {
    @Published public var currentStreak: Int = 0
    @Published public var longestStreak: Int = 0
    
    private let service: StreakServiceProtocol
    
    @MainActor
    public init(service: StreakServiceProtocol? = nil) {
        self.service = service ?? StreakService()
        loadStreak()
    }
    
    public func loadStreak() {
        do {
            let streak = try service.getCurrentStreak()
            self.currentStreak = streak.currentCount
            self.longestStreak = streak.longestStreak
        } catch {
            print("Error loading streak: \(error)")
        }
    }
    
    public func recordActivity() {
        do {
            let updated = try service.updateStreak()
            self.currentStreak = updated.currentCount
            self.longestStreak = updated.longestStreak
        } catch {
            print("Error updating streak: \(error)")
        }
    }
}

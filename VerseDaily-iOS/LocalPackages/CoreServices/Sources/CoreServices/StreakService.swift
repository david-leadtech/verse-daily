import Foundation
import SwiftData
import CoreModels
import CorePersistence

public protocol StreakServiceProtocol {
    func updateStreak() throws -> UserStreak
    func getCurrentStreak() throws -> UserStreak
}

@MainActor
public final class StreakService: StreakServiceProtocol {
    private let context: ModelContext
    
    @MainActor
    public init(context: ModelContext? = nil) {
        self.context = context ?? PersistenceContainer.shared.container.mainContext
    }
    
    public func getCurrentStreak() throws -> UserStreak {
        let descriptor = FetchDescriptor<UserStreak>()
        let results = try context.fetch(descriptor)
        
        if let streak = results.first {
            return streak
        } else {
            let newStreak = UserStreak()
            context.insert(newStreak)
            try context.save()
            return newStreak
        }
    }
    
    public func updateStreak() throws -> UserStreak {
        let streak = try getCurrentStreak()
        let now = Date()
        let calendar = Calendar.current
        
        guard let lastDate = streak.lastActivityDate else {
            // First time activity
            streak.currentCount = 1
            streak.longestStreak = 1
            streak.lastActivityDate = now
            try context.save()
            return streak
        }
        
        if calendar.isDateInToday(lastDate) {
            // Already updated today, do nothing
            return streak
        } else if calendar.isDateInYesterday(lastDate) {
            // Consecutive day
            streak.currentCount += 1
            streak.longestStreak = max(streak.longestStreak, streak.currentCount)
            streak.lastActivityDate = now
        } else {
            // Gap in activity - reset
            streak.currentCount = 1
            streak.lastActivityDate = now
        }
        
        try context.save()
        return streak
    }
}

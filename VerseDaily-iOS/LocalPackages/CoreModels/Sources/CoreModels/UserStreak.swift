import Foundation
import SwiftData

@Model
public final class UserStreak {
    public var currentCount: Int
    public var longestStreak: Int
    public var lastActivityDate: Date?
    
    public init(currentCount: Int = 0, longestStreak: Int = 0, lastActivityDate: Date? = nil) {
        self.currentCount = currentCount
        self.longestStreak = longestStreak
        self.lastActivityDate = lastActivityDate
    }
}

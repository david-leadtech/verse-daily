import Foundation

public struct UserSettings: Codable, Sendable, Equatable {
    public var notificationsEnabled: Bool
    public var notificationTime: String
    public var bibleVersion: String
    public var isPremium: Bool
    
    public init(notificationsEnabled: Bool = true, 
                notificationTime: String = "08:00", 
                bibleVersion: String = "KJV", 
                isPremium: Bool = false) {
        self.notificationsEnabled = notificationsEnabled
        self.notificationTime = notificationTime
        self.bibleVersion = bibleVersion
        self.isPremium = isPremium
    }
}

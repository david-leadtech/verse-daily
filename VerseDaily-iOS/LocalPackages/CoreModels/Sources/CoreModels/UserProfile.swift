import Foundation
import SwiftData

@Model
public final class UserProfile {
    @Attribute(.unique) public var id: String = UUID().uuidString

    // Profile Data
    public var userName: String?
    public var userEmail: String?
    public var ageRange: String?
    public var gender: String?

    // Religious Preferences
    public var church: String?
    public var canon: String = "protestant"
    public var showAdditionalBooks: Bool = false
    public var readingPreferences: [String]? = []

    // Theme & Language
    public var appTheme: String = "system"
    public var textSize: String = "normal"
    public var appLanguage: String = "es"

    // Engagement
    public var readingGoal: String?

    // Metadata
    public var hasCompletedOnboarding: Bool = false
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()

    public init(
        userName: String? = nil,
        userEmail: String? = nil,
        ageRange: String? = nil,
        gender: String? = nil,
        church: String? = nil,
        canon: String = "protestant",
        showAdditionalBooks: Bool = false,
        readingPreferences: [String]? = nil,
        appTheme: String = "system",
        textSize: String = "normal",
        appLanguage: String = "es",
        readingGoal: String? = nil,
        hasCompletedOnboarding: Bool = false
    ) {
        self.userName = userName
        self.userEmail = userEmail
        self.ageRange = ageRange
        self.gender = gender
        self.church = church
        self.canon = canon
        self.showAdditionalBooks = showAdditionalBooks
        self.readingPreferences = readingPreferences ?? []
        self.appTheme = appTheme
        self.textSize = textSize
        self.appLanguage = appLanguage
        self.readingGoal = readingGoal
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}

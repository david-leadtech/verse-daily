import Foundation
import SwiftData

@Model
public final class PrayerEntry: Identifiable {
    public var id: UUID
    public var title: String
    public var content: String
    public var date: Date
    public var liturgicalColor: String // Key for hex code or enum raw value
    public var verseReference: String? // If linked to a verse
    
    public init(
        title: String = "",
        content: String = "",
        date: Date = Date(),
        liturgicalColor: String = "green",
        verseReference: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = date
        self.liturgicalColor = liturgicalColor
        self.verseReference = verseReference
    }
}

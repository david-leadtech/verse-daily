import Foundation

public enum LiturgicalColor: String, CaseIterable {
    case green // Ordinary Time
    case violet // Advent, Lent
    case white // Christmas, Easter
    case red // Pentecost, Martyrs
    
    // Support initialization from the string matching the API response
    public init(string: String) {
        self = LiturgicalColor(rawValue: string.lowercased()) ?? .green
    }
}

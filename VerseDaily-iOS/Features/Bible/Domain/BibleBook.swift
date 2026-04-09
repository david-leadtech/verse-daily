import Foundation

public enum Testament: String, Codable, Sendable, Hashable {
    case old = "Old Testament"
    case new = "New Testament"
}

public struct BibleBook: Identifiable, Codable, Sendable, Hashable, Equatable {
    public var id: String { name }
    public let name: String
    public let testament: Testament
    public let chapters: Int
    
    public init(name: String, testament: Testament, chapters: Int) {
        self.name = name
        self.testament = testament
        self.chapters = chapters
    }
}

import Foundation

public struct Devotional: Identifiable, Codable, Sendable, Hashable, Equatable {
    public let id: Int
    public let title: String
    public let category: String
    public let readTime: String
    public let verseReference: String
    public let content: String?
    
    public init(id: Int, title: String, category: String, readTime: String, verseReference: String, content: String? = nil) {
        self.id = id
        self.title = title
        self.category = category
        self.readTime = readTime
        self.verseReference = verseReference
        self.content = content
    }
}

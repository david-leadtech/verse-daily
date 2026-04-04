import Foundation
import SharedKernel

public struct VerseDTO: Identifiable, Sendable {
    public let id: Int
    public let Reference: String
    public let text: String
    public let version: String
    public let reflection: String?
    
    public init(id: Int, Reference: String, text: String, version: String, reflection: String?) {
        self.id = id
        self.Reference = Reference
        self.text = text
        self.version = version
        self.reflection = reflection
    }
}

public struct DevotionalDTO: Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let category: String
    public let readTime: String
    public let verseReference: String
    
    public init(id: Int, title: String, category: String, readTime: String, verseReference: String) {
        self.id = id
        self.title = title
        self.category = category
        self.readTime = readTime
        self.verseReference = verseReference
    }
}

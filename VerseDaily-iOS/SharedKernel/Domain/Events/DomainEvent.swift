import Foundation

public protocol DomainEvent: Sendable {
    var eventId: UUID { get }
    var occurredAt: Date { get }
    var eventType: String { get }
}

public extension DomainEvent {
    var eventId: UUID { UUID() }
    var occurredAt: Date { Date() }
}

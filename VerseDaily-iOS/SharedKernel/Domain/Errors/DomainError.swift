import Foundation

public enum DomainError: Error, Equatable, Sendable, Hashable {
    case notFound(String)
    case validationFailed(String)
    case unauthorized(String)
    case operationFailed(String)
    case persistenceError(String)
    case networkError(String)
    case unknown(String)
}

public enum ValidationError: Error, Equatable, Sendable, Hashable {
    case emptyValue(field: String)
    case invalidFormat(field: String, reason: String)
    case outOfRange(field: String, min: Double, max: Double)
}

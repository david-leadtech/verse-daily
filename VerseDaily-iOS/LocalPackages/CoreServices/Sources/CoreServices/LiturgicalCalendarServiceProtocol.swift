import Foundation
import CoreModels

public enum LiturgicalCalendarError: Error {
    case invalidURL
    case networkError(Error)
    case unprocessableResponse
    case decodingError(Error)
}

public protocol LiturgicalCalendarServiceProtocol {
    func getToday() async throws -> LiturgicalDay
    func getDate(_ date: Date) async throws -> LiturgicalDay
}

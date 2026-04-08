import Foundation
import CoreModels

public final class InadiutoriumCalendarClient: LiturgicalCalendarServiceProtocol {
    private let baseURL = "https://calapi.inadiutorium.cz/api/v0/en/calendars/default"
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func getToday() async throws -> LiturgicalDay {
        guard let url = URL(string: "\(baseURL)/today") else {
            throw LiturgicalCalendarError.invalidURL
        }
        return try await fetch(from: url)
    }
    
    public func getDate(_ date: Date) async throws -> LiturgicalDay {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        // Force English locale to match API path format correctly
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let dateString = formatter.string(from: date)
        guard let url = URL(string: "\(baseURL)/\(dateString)") else {
            throw LiturgicalCalendarError.invalidURL
        }
        
        return try await fetch(from: url)
    }
    
    private func fetch(from url: URL) async throws -> LiturgicalDay {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(from: url)
        } catch {
            throw LiturgicalCalendarError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw LiturgicalCalendarError.unprocessableResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(LiturgicalDay.self, from: data)
        } catch {
            throw LiturgicalCalendarError.decodingError(error)
        }
    }
}

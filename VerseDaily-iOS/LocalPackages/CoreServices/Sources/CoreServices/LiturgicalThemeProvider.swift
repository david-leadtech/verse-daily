import Foundation
import DesignSystem
import CoreModels

public final class LiturgicalThemeProvider {
    private let client: LiturgicalCalendarServiceProtocol
    
    public init(client: LiturgicalCalendarServiceProtocol = InadiutoriumCalendarClient()) {
        self.client = client
    }
    
    public func themeForToday() async throws -> AppTheme {
        let day = try await client.getToday()
        // Use the colour of the first celebration of the day, defaulting to green if none exists
        let colourString = day.celebrations.first?.colour ?? "green"
        let colour = LiturgicalColor(string: colourString)
        return AppTheme.liturgical(colour)
    }
}

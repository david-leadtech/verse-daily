import SwiftUI
import DesignSystem
import CoreModels

@MainActor
public final class LiturgicalViewModel: ObservableObject {
    @Published public private(set) var day: LiturgicalDay?
    @Published public private(set) var theme: AppTheme = .standard
    @Published public private(set) var errorMessage: String?
    
    private let client: LiturgicalCalendarServiceProtocol
    private let cacheKey = "cachedLiturgicalDay"
    
    public init(client: LiturgicalCalendarServiceProtocol = InadiutoriumCalendarClient()) {
        self.client = client
    }
    
    public func loadToday() async {
        // 1. Try Cache First
        if let cached = UserDefaults.standard.data(forKey: cacheKey),
           let decoded = try? JSONDecoder().decode(LiturgicalDay.self, from: cached) {
            self.day = decoded
            let colourString = decoded.celebrations.first?.colour ?? "green"
            self.theme = AppTheme.liturgical(LiturgicalColor(string: colourString))
        }
        
        // 2. Refresh from Network
        do {
            let fetchedDay = try await client.getToday()
            self.day = fetchedDay
            let fetchedColourString = fetchedDay.celebrations.first?.colour ?? "green"
            self.theme = AppTheme.liturgical(LiturgicalColor(string: fetchedColourString))
            
            // 3. Update Cache
            if let data = try? JSONEncoder().encode(fetchedDay) {
                UserDefaults.standard.set(data, forKey: cacheKey)
            }
            self.errorMessage = nil
            print("Liturgical data loaded successfully: \(fetchedDay.season)")
        } catch {
            // Keep existing data if cached, but set error
            self.errorMessage = error.localizedDescription
            print("Error loading liturgical data: \(error)")
        }
    }
}

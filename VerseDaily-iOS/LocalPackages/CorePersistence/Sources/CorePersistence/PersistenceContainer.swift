import SwiftData
import CoreModels

@MainActor
public final class PersistenceContainer {
    public static let shared = PersistenceContainer()
    
    public let container: ModelContainer
    
    private init() {
        let schema = Schema([
            PrayerEntry.self,
            UserStreak.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}

import SwiftUI
import CoreModels
import CoreServices
import DesignSystem

@MainActor
public final class PrayerJournalViewModel: ObservableObject {
    @Published public var entries: [PrayerEntry] = []
    @Published public var errorMessage: String?
    
    private let service: PrayerServiceProtocol
    
    @MainActor
    public init(service: PrayerServiceProtocol? = nil) {
        self.service = service ?? PrayerService()
        loadEntries()
    }
    
    public func loadEntries() {
        do {
            self.entries = try service.fetchEntries()
        } catch {
            self.errorMessage = "Failed to load prayers: \(error.localizedDescription)"
        }
    }
    
    public func addEntry(title: String, content: String, liturgicalColor: String, verseReference: String?) {
        let newEntry = PrayerEntry(
            title: title,
            content: content,
            date: Date(),
            liturgicalColor: liturgicalColor,
            verseReference: verseReference
        )
        
        do {
            try service.addEntry(newEntry)
            loadEntries()
        } catch {
            self.errorMessage = "Failed to save prayer: \(error.localizedDescription)"
        }
    }
    
    public func deleteEntry(at indexSet: IndexSet) {
        for index in indexSet {
            let entry = entries[index]
            do {
                try service.deleteEntry(entry)
            } catch {
                self.errorMessage = "Failed to delete: \(error.localizedDescription)"
            }
        }
        loadEntries()
    }
}

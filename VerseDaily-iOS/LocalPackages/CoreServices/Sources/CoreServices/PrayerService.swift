import Foundation
import SwiftData
import CoreModels
import CorePersistence

public protocol PrayerServiceProtocol {
    func fetchEntries() throws -> [PrayerEntry]
    func addEntry(_ entry: PrayerEntry) throws
    func deleteEntry(_ entry: PrayerEntry) throws
    func save() throws
}

@MainActor
public final class PrayerService: PrayerServiceProtocol {
    private let context: ModelContext
    
    @MainActor
    public init(context: ModelContext? = nil) {
        self.context = context ?? PersistenceContainer.shared.container.mainContext
    }
    
    public func fetchEntries() throws -> [PrayerEntry] {
        let descriptor = FetchDescriptor<PrayerEntry>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    public func addEntry(_ entry: PrayerEntry) throws {
        context.insert(entry)
        try save()
    }
    
    public func deleteEntry(_ entry: PrayerEntry) throws {
        context.delete(entry)
        try save()
    }
    
    public func save() throws {
        try context.save()
    }
}

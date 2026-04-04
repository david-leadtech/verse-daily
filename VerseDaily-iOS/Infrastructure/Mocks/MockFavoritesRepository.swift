import Foundation

public final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    private var favorites: [Int: VerseDTO] = [:]
    
    public init() {}
    
    public func getFavorites() async throws -> [VerseDTO] {
        return Array(favorites.values)
    }
    
    public func isFavorite(id: Int) async throws -> Bool {
        return favorites[id] != nil
    }
    
    public func toggleFavorite(verse: VerseDTO) async throws {
        if favorites[verse.id] != nil {
            favorites.removeValue(forKey: verse.id)
        } else {
            favorites[verse.id] = verse
        }
    }
}

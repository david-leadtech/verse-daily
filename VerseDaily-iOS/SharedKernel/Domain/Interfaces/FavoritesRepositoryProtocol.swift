import Foundation

public protocol FavoritesRepositoryProtocol: Sendable {
    func getFavorites() async throws -> [VerseDTO]
    func isFavorite(id: Int) async throws -> Bool
    func toggleFavorite(verse: VerseDTO) async throws
}

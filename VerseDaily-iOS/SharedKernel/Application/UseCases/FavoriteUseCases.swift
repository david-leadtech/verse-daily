import Foundation

public struct ToggleFavoriteUseCase {
    private let repository: FavoritesRepositoryProtocol
    
    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(verse: VerseDTO) async throws {
        try await repository.toggleFavorite(verse: verse)
    }
    
    public func isFavorite(id: Int) async throws -> Bool {
        return try await repository.isFavorite(id: id)
    }
}

public struct GetFavoriteVersesUseCase {
    private let repository: FavoritesRepositoryProtocol
    
    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [VerseDTO] {
        return try await repository.getFavorites()
    }
}

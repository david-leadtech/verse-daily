import Foundation
import Combine

@MainActor
public final class SavedVersesViewModel: ObservableObject {
    @Published public var savedVerses: [VerseDTO] = []
    @Published public var isLoading: Bool = false
    
    private let getFavoritesUseCase: GetFavoriteVersesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    
    public init(getFavoritesUseCase: GetFavoriteVersesUseCase, toggleFavoriteUseCase: ToggleFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }
    
    public func loadFavorites() async {
        isLoading = true
        do {
            self.savedVerses = try await getFavoritesUseCase.execute()
        } catch {
            print("Error loading favorites: \(error)")
        }
        isLoading = false
    }
    
    public func toggleFavorite(_ verse: VerseDTO) async {
        do {
            try await toggleFavoriteUseCase.execute(verse: verse)
            await loadFavorites()
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}

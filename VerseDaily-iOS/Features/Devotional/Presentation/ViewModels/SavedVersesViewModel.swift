import Foundation
import Combine

@MainActor
public final class SavedVersesViewModel: ObservableObject {
    @Published public var savedVerses: [VerseDTO] = []
    @Published public var isLoading: Bool = false
    @Published public var error: LocalizedError?

    private let getFavoritesUseCase: GetFavoriteVersesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase

    public init(getFavoritesUseCase: GetFavoriteVersesUseCase, toggleFavoriteUseCase: ToggleFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }

    public func loadFavorites() async {
        isLoading = true
        error = nil
        do {
            self.savedVerses = try await getFavoritesUseCase.execute()
        } catch let error as LocalizedError {
            self.error = error
        } catch {
            // Generic error fallback
            print("Error loading favorites: \(error)")
        }
        isLoading = false
    }

    public func toggleFavorite(_ verse: VerseDTO) async {
        do {
            try await toggleFavoriteUseCase.execute(verse: verse)
            await loadFavorites()
        } catch let error as LocalizedError {
            self.error = error
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}

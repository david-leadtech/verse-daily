import Foundation

// MARK: - Infrastructure
// Note: These infrastructure implementations are imported automatically from the project target

// MARK: - Presentation (ViewModels)
// Note: Xcode should auto-link these from the project target
// If you see "Cannot find type" errors, ensure these files are included in Build Phases

public final class DependencyContainer: Sendable {
    public static let shared = DependencyContainer()
    
    // Repositories
    public let devotionalRepository: DevotionalRepositoryProtocol
    public let bibleRepository: BibleRepositoryProtocol
    public let monetizationRepository: MonetizationRepositoryProtocol
    public let userRepository: UserRepositoryProtocol
    public let favoritesRepository: FavoritesRepositoryProtocol
    
    // Integrations
    public let devotionalIntegration: DevotionalIntegration
    public let monetizationIntegration: MonetizationIntegration
    public let userIntegration: UserIntegration
    
    // Use Cases
    public let getDailyVerseUseCase: GetDailyVerseUseCase
    public let getDevotionalsUseCase: GetDevotionalsUseCase
    public let getBibleBooksUseCase: GetBibleBooksUseCase
    public let getBibleVersesUseCase: GetBibleVersesUseCase
    public let getUserSettingsUseCase: GetUserSettingsUseCase
    public let updateUserSettingsUseCase: UpdateUserSettingsUseCase
    public let getSubscriptionPlansUseCase: GetSubscriptionPlansUseCase
    public let subscribeUseCase: SubscribeUseCase
    public let getFavoriteVersesUseCase: GetFavoriteVersesUseCase
    public let toggleFavoriteUseCase: ToggleFavoriteUseCase
    public let completeOnboardingUseCase: CompleteOnboardingUseCaseProtocol
    
    private init() {
        // Init Repos
        let devotionalRepo = MockDevotionalRepository()
        let bibleRepo = MockBibleRepository()
        // Use real RevenueCat integration for monetization
        let monetizationRepo = RevenueCatMonetizationRepository()
        let userRepo = MockUserRepository()
        let favoritesRepo = MockFavoritesRepository()
        
        self.devotionalRepository = devotionalRepo
        self.bibleRepository = bibleRepo
        self.monetizationRepository = monetizationRepo
        self.userRepository = userRepo
        self.favoritesRepository = favoritesRepo
        
        // Init Integrations
        self.devotionalIntegration = DevotionalIntegrationImpl(repository: devotionalRepo)
        self.monetizationIntegration = MonetizationIntegrationImpl(repository: monetizationRepo)
        self.userIntegration = UserIntegrationImpl(repository: userRepo)
        
        // Init Use Cases
        self.getDailyVerseUseCase = GetDailyVerseUseCase(repository: devotionalRepo)
        self.getDevotionalsUseCase = GetDevotionalsUseCase(repository: devotionalRepo)
        self.getBibleBooksUseCase = GetBibleBooksUseCase(repository: bibleRepo)
        self.getBibleVersesUseCase = GetBibleVersesUseCase(repository: bibleRepo)
        self.getUserSettingsUseCase = GetUserSettingsUseCase(repository: userRepo)
        self.updateUserSettingsUseCase = UpdateUserSettingsUseCase(repository: userRepo)
        self.getSubscriptionPlansUseCase = GetSubscriptionPlansUseCase(repository: monetizationRepo)
        self.subscribeUseCase = SubscribeUseCase(repository: monetizationRepo)
        self.getFavoriteVersesUseCase = GetFavoriteVersesUseCase(repository: favoritesRepo)
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoritesRepo)
        self.completeOnboardingUseCase = CompleteOnboardingUseCase(userRepository: userRepo)
    }
    
    public func resolveHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            getDailyVerseUseCase: getDailyVerseUseCase,
            getDevotionalsUseCase: getDevotionalsUseCase
        )
    }
    
    public func resolveBibleViewModel() -> BibleViewModel {
        return BibleViewModel(
            getBooksUseCase: getBibleBooksUseCase,
            getVersesUseCase: getBibleVersesUseCase
        )
    }
    
    public func resolveSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(
            getUserSettingsUseCase: getUserSettingsUseCase,
            updateUserSettingsUseCase: updateUserSettingsUseCase
        )
    }
    
    public func resolveMonetizationViewModel() -> MonetizationViewModel {
        return MonetizationViewModel(
            getPlansUseCase: getSubscriptionPlansUseCase,
            subscribeUseCase: subscribeUseCase
        )
    }
    
    public func resolveSavedVersesViewModel() -> SavedVersesViewModel {
        return SavedVersesViewModel(
            getFavoritesUseCase: getFavoriteVersesUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }
}

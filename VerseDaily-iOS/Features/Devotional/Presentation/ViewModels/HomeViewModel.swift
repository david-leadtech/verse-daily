import Foundation
import Combine
import SharedKernel

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public var dailyVerse: VerseDTO?
    @Published public var devotionals: [DevotionalDTO] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    
    private let getDailyVerseUseCase: GetDailyVerseUseCase
    private let getDevotionalsUseCase: GetDevotionalsUseCase
    
    public init(getDailyVerseUseCase: GetDailyVerseUseCase, getDevotionalsUseCase: GetDevotionalsUseCase) {
        self.getDailyVerseUseCase = getDailyVerseUseCase
        self.getDevotionalsUseCase = getDevotionalsUseCase
    }
    
    public func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let verseTask = getDailyVerseUseCase.execute()
            async let devotionalsTask = getDevotionalsUseCase.execute()
            
            self.dailyVerse = try await verseTask
            self.devotionals = try await devotionalsTask
        } catch {
            self.errorMessage = "Failed to load daily content. Please try again."
        }
        
        isLoading = false
    }
}

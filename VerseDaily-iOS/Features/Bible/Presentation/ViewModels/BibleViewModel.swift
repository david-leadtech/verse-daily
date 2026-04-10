import Foundation
import Combine

public enum BibleNavigationState: Sendable {
    case bookSelection
    case chapterSelection(BibleBookDTO)
    case reader(BibleBookDTO, Int)
}

@MainActor
public final class BibleViewModel: ObservableObject {
    @Published public var navigationState: BibleNavigationState = .bookSelection
    @Published public var books: [BibleBookDTO] = []
    @Published public var verses: [VerseDTO] = []
    @Published public var isLoading: Bool = false
    @Published public var error: LocalizedError?
    @Published public var lastReadingSession: ReadingSession?
    @Published public var currentReadingSession: ReadingSession?

    private let getBooksUseCase: GetBibleBooksUseCase
    private let getVersesUseCase: GetBibleVersesUseCase

    public init(getBooksUseCase: GetBibleBooksUseCase, getVersesUseCase: GetBibleVersesUseCase) {
        self.getBooksUseCase = getBooksUseCase
        self.getVersesUseCase = getVersesUseCase
    }

    public func loadBooks() async {
        isLoading = true
        error = nil
        do {
            self.books = try await getBooksUseCase.execute()
        } catch let err as LocalizedError {
            self.error = err
        } catch {
            print("Error loading books: \(error)")
        }
        isLoading = false
    }
    
    public func selectBook(_ book: BibleBookDTO) {
        navigationState = .chapterSelection(book)
    }
    
    public func selectChapter(_ chapter: Int, in book: BibleBookDTO) async {
        navigationState = .reader(book, chapter)
        await loadVerses(book: book.name, chapter: chapter)
    }
    
    public func goBack() {
        switch navigationState {
        case .bookSelection:
            break
        case .chapterSelection:
            navigationState = .bookSelection
        case .reader(let book, _):
            navigationState = .chapterSelection(book)
            verses = []
        }
    }
    
    public func loadVerses(book: String, chapter: Int) async {
        isLoading = true
        error = nil
        do {
            self.verses = try await getVersesUseCase.execute(book: book, chapter: chapter)
            startReadingSession(book: book, chapter: chapter)
        } catch let err as LocalizedError {
            self.error = err
        } catch {
            print("Error loading verses: \(error)")
        }
        isLoading = false
    }

    /// Load the last reading session to show "Resume Reading" option
    public func loadLastSession() {
        // TODO: Load from SwiftData when infrastructure is set up
        // For now, this is a placeholder for the feature
    }

    /// Start a new reading session or resume the current one
    private func startReadingSession(book: String, chapter: Int) {
        let session = ReadingSession(book: book, chapter: chapter)
        currentReadingSession = session
        lastReadingSession = session
    }

    /// Update progress in current reading session
    public func updateReadingProgress(verseNumber: Int) {
        currentReadingSession?.lastVerseRead = verseNumber
        currentReadingSession?.lastReadAt = Date()
    }

    /// Complete the current reading session
    public func completeReadingSession() {
        if let session = currentReadingSession {
            lastReadingSession = session
            currentReadingSession = nil
        }
    }
}

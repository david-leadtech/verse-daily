import SwiftUI

public struct BibleView: View {
    @StateObject private var viewModel: BibleViewModel
    
    public init(viewModel: BibleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            DS.Tokens.Colors.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                switch viewModel.navigationState {
                case .bookSelection:
                    BookSelectionView(viewModel: viewModel)
                case .chapterSelection(let book):
                    ChapterSelectionView(viewModel: viewModel, book: book)
                case .reader(let book, let chapter):
                    VerseListView(viewModel: viewModel, book: book, chapter: chapter)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadBooks()
            }
        }
        .navigationBarHidden(true)
    }
}

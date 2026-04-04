import SwiftUI

struct ChapterSelectionView: View {
    @ObservedObject var viewModel: BibleViewModel
    let book: BibleBookDTO
    
    private var chapters: [Int] {
        Array(1...book.chapters)
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: 60, maximum: 60), spacing: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            HStack {
                Button(action: { viewModel.goBack() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(DS.Tokens.Colors.tint)
                }
                
                VStack(alignment: .leading) {
                    Text(book.name)
                        .font(DS.Tokens.Typography.playfairBold(size: 24))
                        .foregroundColor(DS.Tokens.Colors.text)
                    Text("Select a chapter")
                        .font(DS.Tokens.Typography.interRegular(size: 14))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                }
            }
            .padding(.horizontal, DS.Tokens.Spacing.md)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(chapters, id: \.self) { chapter in
                        Button(action: {
                            Task {
                                await viewModel.selectChapter(chapter, in: book)
                            }
                        }) {
                            Text("\(chapter)")
                                .font(DS.Tokens.Typography.playfairBold(size: 18))
                                .foregroundColor(DS.Tokens.Colors.text)
                                .frame(width: 60, height: 60)
                                .background(DS.Tokens.Colors.surface)
                                .cornerRadius(14)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(DS.Tokens.Colors.border, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(DS.Tokens.Spacing.md)
            }
        }
    }
}

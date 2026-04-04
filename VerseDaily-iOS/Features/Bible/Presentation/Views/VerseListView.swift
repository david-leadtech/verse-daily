import SwiftUI

struct VerseListView: View {
    @ObservedObject var viewModel: BibleViewModel
    let book: BibleBookDTO
    let chapter: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if viewModel.verses.isEmpty {
                emptyView
            } else {
                ScrollView {
                    LazyVStack(spacing: DS.Tokens.Spacing.md) {
                        ForEach(viewModel.verses.indices, id: \.self) { index in
                            VerseCardView(
                                verse: viewModel.verses[index],
                                colors: DS.Tokens.Colors.cardGradients[index % DS.Tokens.Colors.cardGradients.count]
                            )
                        }
                    }
                    .padding(DS.Tokens.Spacing.md)
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button(action: { viewModel.goBack() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(DS.Tokens.Colors.tint)
            }
            
            Spacer()
            
            Text("\(book.name) \(chapter)")
                .font(DS.Tokens.Typography.playfairBold(size: 18))
                .foregroundColor(DS.Tokens.Colors.text)
            
            Spacer()
            
            // Dummy spacer for balance
            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, DS.Tokens.Spacing.md)
        .padding(.vertical, DS.Tokens.Spacing.sm)
        .background(DS.Tokens.Colors.background)
        .border(DS.Tokens.Colors.border, width: 0.5)
    }
    
    private var emptyView: some View {
        VStack(spacing: DS.Tokens.Spacing.md) {
            Spacer()
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundColor(DS.Tokens.Colors.border)
            Text("No verses found")
                .font(DS.Tokens.Typography.playfairBold(size: 18))
                .foregroundColor(DS.Tokens.Colors.text)
            Text("This chapter doesn't have any verses in our collection yet.")
                .font(DS.Tokens.Typography.interRegular(size: 14))
                .foregroundColor(DS.Tokens.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
}

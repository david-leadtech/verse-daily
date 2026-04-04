import SwiftUI

struct BookSelectionView: View {
    @ObservedObject var viewModel: BibleViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            Text("Select a Book")
                .font(DS.Tokens.Typography.playfairBold(size: 24))
                .foregroundColor(DS.Tokens.Colors.text)
                .padding(.horizontal, DS.Tokens.Spacing.md)
            
            DSTable(viewModel.books) { book in
                HStack(spacing: DS.Tokens.Spacing.md) {
                    DSBadge(
                        book.testament == "Old Testament" ? "OT" : "NT",
                        style: book.testament == "Old Testament" ? .default : .success
                    )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book.name)
                            .font(DS.Tokens.Typography.interMedium(size: 16))
                            .foregroundColor(DS.Tokens.Colors.text)
                        Text("\(book.chapters) chapters")
                            .font(DS.Tokens.Typography.interRegular(size: 13))
                            .foregroundColor(DS.Tokens.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(DS.Tokens.Colors.border)
                }
                .padding(.vertical, DS.Tokens.Spacing.sm)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectBook(book)
                }
            }
        }
    }
}

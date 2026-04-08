import SwiftUI
import DesignSystem

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    // Header section
                    header
                        .padding(.vertical, DS.Tokens.Spacing.lg)

                    // Daily verse section
                    VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
                        Text("Verse of the Day")
                            .font(DS.Tokens.Typography.interMedium(size: 12))
                            .foregroundColor(DS.Tokens.Colors.textSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                            .padding(.horizontal, DS.Tokens.Spacing.lg)

                        VerseCardView(
                            verse: viewModel.dailyVerse,
                            onReadChapter: {}
                        )
                        .padding(.horizontal, DS.Tokens.Spacing.lg)
                    }
                    .padding(.vertical, DS.Tokens.Spacing.xl)

                    // Devotionals section
                    devotionalsSection
                        .padding(.vertical, DS.Tokens.Spacing.xl)

                    Spacer(minLength: DS.Tokens.Spacing.lg)
                }
            }
            .background(DS.Tokens.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadData()
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
            HStack(alignment: .top, spacing: DS.Tokens.Spacing.md) {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
                    Text("Good Morning")
                        .font(DS.Tokens.Typography.interMedium(size: 13))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)

                    Text("David")
                        .font(DS.Tokens.Typography.playfairBold(size: 32))
                        .foregroundColor(DS.Tokens.Colors.text)

                    Text(formattedDate())
                        .font(DS.Tokens.Typography.interRegular(size: 13))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "bell.badge")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(DS.Tokens.Colors.background)
                        .frame(width: 44, height: 44)
                        .background(DS.Tokens.Colors.tint)
                        .clipShape(Circle())
                        .shadow(color: DS.Tokens.Colors.tint.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.horizontal, DS.Tokens.Spacing.lg)
        }
    }

    private var devotionalsSection: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            Text("Today's Devotionals")
                .font(DS.Tokens.Typography.playfairBold(size: 22))
                .foregroundColor(DS.Tokens.Colors.text)
                .padding(.horizontal, DS.Tokens.Spacing.lg)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DS.Tokens.Spacing.md) {
                    ForEach(viewModel.devotionals) { devotional in
                        DevotionalCard(devotional: devotional)
                    }
                }
                .padding(.horizontal, DS.Tokens.Spacing.lg)
            }
        }
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

struct DevotionalCard: View {
    let devotional: DevotionalDTO
    @State private var isSelected = false

    var body: some View {
        Button(action: { isSelected.toggle() }) {
            DSCard {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
                    HStack(alignment: .top, spacing: DS.Tokens.Spacing.sm) {
                        DSBadge(devotional.category)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(DS.Tokens.Colors.tint)
                            .rotationEffect(.degrees(isSelected ? 90 : 0))
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
                        Text(devotional.title)
                            .font(DS.Tokens.Typography.playfairBold(size: 20))
                            .foregroundColor(DS.Tokens.Colors.text)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: DS.Tokens.Spacing.sm) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(DS.Tokens.Colors.accent)

                            Text(devotional.readTime)
                                .font(DS.Tokens.Typography.interMedium(size: 13))
                                .foregroundColor(DS.Tokens.Colors.textSecondary)
                        }
                    }
                }
            }
            .frame(width: 280, height: 180)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            .scaleEffect(isSelected ? 0.98 : 1.0)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}


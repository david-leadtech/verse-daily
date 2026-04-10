import SwiftUI
import DesignSystem
import CoreModels
import SwiftData

public struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.appTheme) var theme: DesignSystem.AppTheme
    @State private var isPremium = false
    @State private var showPaywall = false
    @State private var selectedChapter: (book: String, chapter: Int)?
    @State private var showFullChapter = false
    @State private var lastReadingSession: ReadingSession?
    @Query(sort: \ReadingSession.lastReadAt, order: .reverse) private var readingSessions: [ReadingSession]

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    header
                        .padding(.vertical, DS.Tokens.Spacing.lg)

                    // Resume Reading Banner
                    if let lastSession = readingSessions.first {
                        resumeReadingBanner(for: lastSession)
                            .padding(.horizontal, DS.Tokens.Spacing.lg)
                            .padding(.vertical, DS.Tokens.Spacing.md)
                    }

                    VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
                        Text(LocalizationKey.homeVerseOfTheDay.localized)
                            .font(DS.Tokens.Typography.interMedium(size: 12))
                            .foregroundColor(DS.Tokens.Colors.textSecondary)
                            .textCase(.uppercase)
                            .tracking(0.5)
                            .padding(.horizontal, DS.Tokens.Spacing.lg)

                        VerseCardView(
                            verse: viewModel.dailyVerse,
                            onReadChapter: {
                                if let verse = viewModel.dailyVerse,
                                   let (book, chapter) = parseReference(verse.Reference) {
                                    selectedChapter = (book: book, chapter: chapter)
                                    showFullChapter = true
                                }
                            }
                        )
                        .padding(.horizontal, DS.Tokens.Spacing.lg)
                    }
                    .padding(.vertical, DS.Tokens.Spacing.xl)

                    if isPremium {
                        devotionalsSection
                            .padding(.vertical, DS.Tokens.Spacing.xl)
                    } else {
                        premiumPromoBanner
                            .padding(.vertical, DS.Tokens.Spacing.xl)
                    }

                    Spacer(minLength: DS.Tokens.Spacing.lg)
                }
            }
            .background(DS.Tokens.Colors.background.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await viewModel.loadData()
                    await checkPremiumStatus()
                }
            }
            .sheet(isPresented: $showPaywall) {
                SubscriptionView(viewModel: DependencyContainer.shared.resolveMonetizationViewModel())
            }
            .sheet(isPresented: $showFullChapter) {
                if let selectedChapter = selectedChapter {
                    SavedChapterView(
                        bookName: selectedChapter.book,
                        chapter: selectedChapter.chapter,
                        isPresented: $showFullChapter
                    )
                    .environment(\.appTheme, theme)
                }
            }
        }
    }

    private func parseReference(_ reference: String) -> (book: String, chapter: Int)? {
        let components = reference.split(separator: " ")
        guard components.count >= 2 else { return nil }
        let bookName = String(components[0])
        let chapterString = String(components[1]).split(separator: ":").first.map(String.init) ?? ""
        guard let chapter = Int(chapterString) else { return nil }
        return (book: bookName, chapter: chapter)
    }

    private func checkPremiumStatus() async {
        do {
            let isPremiumNow = await MonetizationIntegrationImpl(
                repository: DependencyContainer.shared.monetizationRepository
            ).isPremiumUser()
            await MainActor.run {
                self.isPremium = isPremiumNow
            }
        } catch {
            print("Error checking premium status: \(error)")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
            HStack(alignment: .top, spacing: DS.Tokens.Spacing.md) {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
                    Text(LocalizationKey.homeGreetingGoodMorning.localized)
                        .font(DS.Tokens.Typography.interMedium(size: 13))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)

                    Text(viewModel.dailyVerse?.Reference ?? "David")
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
            Text(LocalizationKey.homeTodaysDevotionals.localized)
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

    private var premiumPromoBanner: some View {
        VStack(alignment: .leading, spacing: DS.Tokens.Spacing.md) {
            HStack(spacing: DS.Tokens.Spacing.md) {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.sm) {
                    Text(LocalizationKey.homePremiumFeature.localized)
                        .font(DS.Tokens.Typography.interMedium(size: 12))
                        .foregroundColor(DS.Tokens.Colors.tint)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    Text(LocalizationKey.homeUnlockDevotionals.localized)
                        .font(DS.Tokens.Typography.playfairBold(size: 20))
                        .foregroundColor(DS.Tokens.Colors.text)

                    Text(LocalizationKey.homeDevotionalsDesc.localized)
                        .font(DS.Tokens.Typography.interRegular(size: 13))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "lock.fill")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(DS.Tokens.Colors.tint.opacity(0.5))
            }
            .padding(20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        DS.Tokens.Colors.accent.opacity(0.1),
                        DS.Tokens.Colors.tint.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal, DS.Tokens.Spacing.lg)

            Button(action: { showPaywall = true }) {
                Text(LocalizationKey.homeUpgradePremium.localized)
                    .font(DS.Tokens.Typography.interMedium(size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(DS.Tokens.Colors.tint)
                    .cornerRadius(12)
            }
            .padding(.horizontal, DS.Tokens.Spacing.lg)
        }
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }

    private func resumeReadingBanner(for session: ReadingSession) -> some View {
        Button(action: {
            selectedChapter = (book: session.book, chapter: session.chapter)
            showFullChapter = true
        }) {
            HStack(spacing: DS.Tokens.Spacing.md) {
                VStack(alignment: .leading, spacing: DS.Tokens.Spacing.xs) {
                    Text("Continue Reading")
                        .font(DS.Tokens.Typography.interMedium(size: 11))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    HStack(spacing: 4) {
                        Text(session.book)
                            .font(DS.Tokens.Typography.interMedium(size: 16))
                        Text("Chapter \(session.chapter)")
                            .font(DS.Tokens.Typography.interMedium(size: 16))
                    }
                    .foregroundColor(DS.Tokens.Colors.text)

                    Text("Verse \(session.lastVerseRead)")
                        .font(DS.Tokens.Typography.interRegular(size: 12))
                        .foregroundColor(DS.Tokens.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "bookmark.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(DS.Tokens.Colors.accent)
            }
            .padding(16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        DS.Tokens.Colors.accent.opacity(0.12),
                        DS.Tokens.Colors.tint.opacity(0.06)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(DS.Tokens.Colors.accent.opacity(0.3), lineWidth: 1)
            )
        }
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

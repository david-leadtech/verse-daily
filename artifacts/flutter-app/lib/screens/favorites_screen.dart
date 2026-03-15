import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../providers/favorites_provider.dart';
import '../widgets/verse_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favorites = favoritesProvider.favorites;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Favorites', style: AppTheme.playfairBold(28)),
                const SizedBox(height: 4),
                Text(
                  '${favorites.length} ${favorites.length == 1 ? "verse" : "verses"} saved',
                  style: AppTheme.interRegular(14).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (favorites.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceSecondary,
                      ),
                      child: const Icon(FeatherIcons.heart,
                          size: 40, color: AppColors.tabIconDefault),
                    ),
                    const SizedBox(height: 20),
                    Text('No favorites yet',
                        style: AppTheme.playfairBold(20)),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Tap the heart icon on any verse to save it here for easy access later.',
                        textAlign: TextAlign.center,
                        style: AppTheme.interRegular(15).copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final fav = favorites[index];
                  return GestureDetector(
                    onLongPress: () {
                      _showRemoveDialog(context, fav.id,
                          '${fav.book} ${fav.chapter}:${fav.verseNumber}');
                    },
                    child: VerseCard(
                      id: fav.id,
                      book: fav.book,
                      chapter: fav.chapter,
                      verseNumber: fav.verseNumber,
                      text: fav.text,
                      version: fav.version,
                      gradientIndex: index % 8,
                      compact: true,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, int verseId, String verseName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from Favorites'),
        content: Text('Remove "$verseName" from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().removeFavorite(verseId);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

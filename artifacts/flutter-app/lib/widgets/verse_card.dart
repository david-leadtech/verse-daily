import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../providers/favorites_provider.dart';
import 'gradient_card.dart';

const _cardImages = [
  'assets/images/onboarding-1.png',
  'assets/images/onboarding-3.png',
  'assets/images/splash-bg.png',
  'assets/images/daily-verse-bg.png',
];

class VerseCard extends StatelessWidget {
  final int id;
  final String book;
  final int chapter;
  final int verseNumber;
  final String text;
  final String version;
  final int gradientIndex;
  final bool showActions;
  final bool compact;
  final VoidCallback? onPress;
  final bool useImage;

  const VerseCard({
    super.key,
    required this.id,
    required this.book,
    required this.chapter,
    required this.verseNumber,
    required this.text,
    required this.version,
    this.gradientIndex = 0,
    this.showActions = true,
    this.compact = false,
    this.onPress,
    this.useImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final saved = favoritesProvider.isFavorite(id);

    final cardContent = Padding(
      padding: EdgeInsets.all(compact ? 20 : 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u201C$text\u201D',
            style: AppTheme.playfairItalic(compact ? 16 : 20).copyWith(
              color: Colors.white,
              height: compact ? 1.625 : 1.6,
              letterSpacing: 0.3,
              shadows: [
                const Shadow(
                  color: Color(0x80000000),
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$book $chapter:$verseNumber',
                    style: AppTheme.interSemiBold(14).copyWith(
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          color: Color(0x66000000),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    version,
                    style: AppTheme.interRegular(12).copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              if (showActions)
                Row(
                  children: [
                    _ActionButton(
                      icon: FeatherIcons.heart,
                      color: saved
                          ? const Color(0xFFC5963A)
                          : const Color(0x80F5ECD7),
                      onTap: () {
                        favoritesProvider.toggleFavorite(
                          id: id,
                          book: book,
                          chapter: chapter,
                          verseNumber: verseNumber,
                          text: text,
                          version: version,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: FeatherIcons.share,
                      color: const Color(0x80F5ECD7),
                      onTap: () {
                        Share.share(
                          '"$text"\n\n\u2014 $book $chapter:$verseNumber ($version)',
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );

    if (useImage) {
      final imageAsset = _cardImages[gradientIndex % _cardImages.length];
      final wrapper = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xA6140802),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            cardContent,
          ],
        ),
      );

      if (onPress != null) {
        return GestureDetector(onTap: onPress, child: wrapper);
      }
      return wrapper;
    }

    return GradientCard(
      gradientIndex: gradientIndex,
      onPress: onPress,
      child: cardContent,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0x1AF5ECD7),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

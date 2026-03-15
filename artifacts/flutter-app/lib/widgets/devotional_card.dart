import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';

const _categoryIcons = <String, IconData>{
  'Peace': FeatherIcons.sun,
  'Strength': FeatherIcons.shield,
  'Faith': FeatherIcons.compass,
  'Gratitude': FeatherIcons.gift,
  'Love': FeatherIcons.heart,
  'Trust': FeatherIcons.anchor,
  'Growth': FeatherIcons.trendingUp,
  'Rest': FeatherIcons.moon,
  'Courage': FeatherIcons.zap,
};

const _categoryColors = <String, Color>{
  'Peace': Color(0xFF1E3A5F),
  'Strength': Color(0xFF8B2252),
  'Faith': Color(0xFF8B4513),
  'Gratitude': Color(0xFFC5963A),
  'Love': Color(0xFF8B2252),
  'Trust': Color(0xFF5B7D3A),
  'Growth': Color(0xFF3C5A20),
  'Rest': Color(0xFF1E3A5F),
  'Courage': Color(0xFF8B4513),
};

class DevotionalCard extends StatelessWidget {
  final int id;
  final String title;
  final String category;
  final int readTime;
  final String verseReference;
  final VoidCallback onPress;

  const DevotionalCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.verseReference,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = _categoryIcons[category] ?? FeatherIcons.bookOpen;
    final categoryColor = _categoryColors[category] ?? AppColors.tint;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.09),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, size: 22, color: categoryColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.interSemiBold(16).copyWith(
                      color: AppColors.text,
                      height: 1.375,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        verseReference,
                        style: AppTheme.interRegular(13).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.tabIconDefault,
                        ),
                      ),
                      Text(
                        '$readTime min read',
                        style: AppTheme.interRegular(13).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              FeatherIcons.chevronRight,
              size: 20,
              color: AppColors.tabIconDefault,
            ),
          ],
        ),
      ),
    );
  }
}

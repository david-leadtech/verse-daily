import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/devotional.dart';

const _categoryColors = <String, List<Color>>{
  'Peace': [Color(0xFF1E3A5F), Color(0xFF2D5070)],
  'Strength': [Color(0xFF8B2252), Color(0xFF6B1A3D)],
  'Faith': [Color(0xFF8B4513), Color(0xFF6B3410)],
  'Gratitude': [Color(0xFFC5963A), Color(0xFF8B6914)],
  'Love': [Color(0xFF8B2252), Color(0xFF6B1A3D)],
  'Trust': [Color(0xFF5B7D3A), Color(0xFF3C5A20)],
  'Growth': [Color(0xFF3C5A20), Color(0xFF2C4010)],
  'Rest': [Color(0xFF1E3A5F), Color(0xFF14284A)],
  'Courage': [Color(0xFF8B4513), Color(0xFF5C2D0E)],
};

class DevotionalDetailScreen extends StatefulWidget {
  final int devotionalId;
  final ApiService apiService;
  final VoidCallback onBack;

  const DevotionalDetailScreen({
    super.key,
    required this.devotionalId,
    required this.apiService,
    required this.onBack,
  });

  @override
  State<DevotionalDetailScreen> createState() =>
      _DevotionalDetailScreenState();
}

class _DevotionalDetailScreenState extends State<DevotionalDetailScreen> {
  Devotional? _devotional;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDevotional();
  }

  Future<void> _loadDevotional() async {
    try {
      final data = await widget.apiService.getDevotional(widget.devotionalId);
      if (mounted) setState(() {
        _devotional = data;
        _loading = false;
      });
    } catch (e) {
      debugPrint('DevotionalDetailScreen: failed to load devotional: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  void _handleShare() {
    if (_devotional == null) return;
    Share.share(
      '${_devotional!.title}\n\n\u201C${_devotional!.verseText}\u201D\n- ${_devotional!.verseReference}\n\n${_devotional!.content.substring(0, _devotional!.content.length < 200 ? _devotional!.content.length : 200)}...',
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.accent,
          ),
        ),
      );
    }

    if (_devotional == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FeatherIcons.alertCircle,
                  size: 48, color: AppColors.tabIconDefault),
              const SizedBox(height: 16),
              Text(
                'Devotional not found',
                style: AppTheme.interMedium(16).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tint,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Go Back',
                  style: AppTheme.interSemiBold(15).copyWith(
                    color: const Color(0xFFF5ECD7),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final gradientColors = _categoryColors[_devotional!.category] ??
        [const Color(0xFF8B4513), const Color(0xFF5C2D0E)];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPadding + 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.fromLTRB(24, topPadding + 12, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ...gradientColors,
                    gradientColors[1].withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x26F5ECD7),
                          ),
                          child: const Icon(FeatherIcons.chevronLeft,
                              size: 24, color: Color(0xFFF5ECD7)),
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleShare,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0x26F5ECD7),
                          ),
                          child: const Icon(FeatherIcons.share,
                              size: 20, color: Color(0xFFF5ECD7)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x26F5ECD7),
                    ),
                    child: Text(
                      _devotional!.category,
                      style: AppTheme.interSemiBold(13).copyWith(
                        color: const Color(0xFFE8D5A3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _devotional!.title,
                    style: AppTheme.playfairBold(28).copyWith(
                      color: const Color(0xFFF5ECD7),
                      height: 1.286,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(FeatherIcons.clock,
                          size: 14,
                          color: const Color(0xFFF5ECD7).withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Text(
                        '${_devotional!.readTime} min read',
                        style: AppTheme.interRegular(14).copyWith(
                          color:
                              const Color(0xFFF5ECD7).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 3,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\u201C${_devotional!.verseText}\u201D',
                          style: AppTheme.playfairItalic(17).copyWith(
                            height: 1.647,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _devotional!.verseReference,
                          style: AppTheme.interSemiBold(14).copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                children: _devotional!.content
                    .split('\n\n')
                    .map((paragraph) => Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Text(
                            paragraph,
                            style: AppTheme.interRegular(16).copyWith(
                              height: 1.75,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

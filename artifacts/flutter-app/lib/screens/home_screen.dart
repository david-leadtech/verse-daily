import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/verse.dart';
import '../models/devotional.dart';
import '../widgets/verse_card.dart';
import '../widgets/devotional_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;
  final void Function(int tabIndex) onSwitchTab;
  final void Function(int devotionalId) onOpenDevotional;
  final VoidCallback onOpenSettings;
  final void Function(String book, int chapter) onOpenBibleChapter;

  const HomeScreen({
    super.key,
    required this.apiService,
    required this.onSwitchTab,
    required this.onOpenDevotional,
    required this.onOpenSettings,
    required this.onOpenBibleChapter,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DailyVerseResponse? _dailyData;
  List<Devotional> _devotionals = [];
  bool _dailyLoading = true;
  bool _dailyError = false;
  bool _devotionalsLoading = true;
  bool _devotionalsError = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadDailyVerse(), _loadDevotionals()]);
  }

  Future<void> _loadDailyVerse() async {
    setState(() {
      _dailyLoading = true;
      _dailyError = false;
    });
    try {
      final data = await widget.apiService.getDailyVerse();
      if (mounted) setState(() {
        _dailyData = data;
        _dailyLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() {
        _dailyLoading = false;
        _dailyError = true;
      });
    }
  }

  Future<void> _loadDevotionals() async {
    setState(() {
      _devotionalsLoading = true;
      _devotionalsError = false;
    });
    try {
      final data = await widget.apiService.getDevotionals(limit: 5);
      if (mounted) setState(() {
        _devotionals = data.devotionals;
        _devotionalsLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() {
        _devotionalsLoading = false;
        _devotionalsError = true;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _refreshing = true);
    await _loadData();
    if (mounted) setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final today = DateTime.now();
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.tint,
        child: ListView(
          padding: EdgeInsets.only(
            top: topPadding + 16,
            bottom: 100,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting.greeting,
                          style: AppTheme.playfairBold(28)),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(today),
                        style: AppTheme.interRegular(14).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: widget.onOpenSettings,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceSecondary,
                      ),
                      child: const Icon(FeatherIcons.settings,
                          size: 22, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Text(
                greeting.message,
                style: AppTheme.playfairItalic(15).copyWith(
                  color: AppColors.textSecondary,
                  height: 1.533,
                ),
              ),
            ),
            const SectionHeader(title: "Today's Verse"),
            if (_dailyLoading)
              _buildLoadingCard('Finding today\'s verse for you...')
            else if (_dailyError)
              _buildErrorCard('Couldn\'t load your verse right now',
                  onTap: _loadDailyVerse)
            else if (_dailyData?.verse != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    VerseCard(
                      id: _dailyData!.verse!.id,
                      book: _dailyData!.verse!.book,
                      chapter: _dailyData!.verse!.chapter,
                      verseNumber: _dailyData!.verse!.verseNumber,
                      text: _dailyData!.verse!.text,
                      version: _dailyData!.verse!.version,
                      gradientIndex: today.day % 4,
                      useImage: true,
                    ),
                    if (_dailyData!.reflection != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.parchment,
                          borderRadius: BorderRadius.circular(16),
                          border: const Border(
                            left: BorderSide(
                                color: AppColors.accent, width: 3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REFLECTION',
                              style: AppTheme.interSemiBold(11).copyWith(
                                color: AppColors.accent,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _dailyData!.reflection!,
                              style: AppTheme.interRegular(14).copyWith(
                                height: 1.643,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              )
            else
              _buildEmptyCard(FeatherIcons.bookOpen,
                  'No verse for today yet \u2014 check back soon!'),
            const SizedBox(height: 28),
            SectionHeader(
              title: 'For You',
              actionText: 'See all',
              onAction: () => widget.onSwitchTab(1),
            ),
            if (_devotionalsLoading)
              _buildLoadingCard(null)
            else if (_devotionalsError)
              _buildErrorCard('Couldn\'t load devotionals',
                  onTap: _loadDevotionals)
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: _devotionals
                      .map(
                        (dev) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DevotionalCard(
                            id: dev.id,
                            title: dev.title,
                            category: dev.category,
                            readTime: dev.readTime,
                            verseReference: dev.verseReference,
                            onPress: () => widget.onOpenDevotional(dev.id),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Quick Read'),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _quickReadTopics.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final topic = _quickReadTopics[index];
                  return GestureDetector(
                    onTap: () => widget.onOpenBibleChapter(
                        topic.book, topic.chapter),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        width: 150,
                        height: 180,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(topic.image, fit: BoxFit.cover),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xA60F0602),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(topic.icon,
                                      size: 20,
                                      color: AppColors.accentLight),
                                  const Spacer(),
                                  Text(
                                    topic.name,
                                    style:
                                        AppTheme.playfairBold(16).copyWith(
                                      color: Colors.white,
                                      height: 1.3125,
                                      shadows: [
                                        const Shadow(
                                          color: Color(0x80000000),
                                          offset: Offset(0, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${topic.book} ${topic.chapter}',
                                    style:
                                        AppTheme.interMedium(12).copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                      shadows: [
                                        const Shadow(
                                          color: Color(0x66000000),
                                          offset: Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(String? message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 10),
              Text(
                message,
                style: AppTheme.interRegular(14).copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FeatherIcons.wifiOff,
                  size: 28, color: AppColors.tabIconDefault),
              const SizedBox(height: 10),
              Text(
                message,
                style: AppTheme.interRegular(14).copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tap to try again',
                style: AppTheme.interMedium(13).copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(IconData icon, String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: AppColors.tabIconDefault),
            const SizedBox(height: 10),
            Text(
              message,
              style: AppTheme.interRegular(14).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  _GreetingMessage _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return const _GreetingMessage(
        greeting: 'Good Morning',
        message:
            'Start your day with a moment of peace. Here\u2019s a verse to carry with you today.',
      );
    }
    if (hour < 17) {
      return const _GreetingMessage(
        greeting: 'Good Afternoon',
        message:
            'Take a pause. Let God\u2019s Word refresh your spirit for the rest of the day.',
      );
    }
    return const _GreetingMessage(
      greeting: 'Good Evening',
      message:
          'Wind down with tonight\u2019s scripture. Let His words bring you peace as you rest.',
    );
  }
}

class _GreetingMessage {
  final String greeting;
  final String message;
  const _GreetingMessage({required this.greeting, required this.message});
}

class _QuickReadTopic {
  final String name;
  final String book;
  final int chapter;
  final IconData icon;
  final String image;
  const _QuickReadTopic({
    required this.name,
    required this.book,
    required this.chapter,
    required this.icon,
    required this.image,
  });
}

const _quickReadTopics = [
  _QuickReadTopic(
      name: 'Psalms of\nPeace',
      book: 'Psalms',
      chapter: 23,
      icon: FeatherIcons.sun,
      image: 'assets/images/onboarding-1.png'),
  _QuickReadTopic(
      name: 'The Love\nChapter',
      book: '1 Corinthians',
      chapter: 13,
      icon: FeatherIcons.heart,
      image: 'assets/images/onboarding-3.png'),
  _QuickReadTopic(
      name: 'In the\nBeginning',
      book: 'Genesis',
      chapter: 1,
      icon: FeatherIcons.globe,
      image: 'assets/images/splash-bg.png'),
  _QuickReadTopic(
      name: 'Heroes of\nFaith',
      book: 'Hebrews',
      chapter: 11,
      icon: FeatherIcons.shield,
      image: 'assets/images/daily-verse-bg.png'),
  _QuickReadTopic(
      name: 'The\nBeatitudes',
      book: 'Matthew',
      chapter: 5,
      icon: FeatherIcons.star,
      image: 'assets/images/onboarding-2.png'),
];

import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'bible_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'devotional_detail_screen.dart';
import 'subscription_screen.dart';

class AppShell extends StatefulWidget {
  final ApiService apiService;

  const AppShell({super.key, required this.apiService});

  @override
  State<AppShell> createState() => _AppShellState();
}

enum _OverlayScreen { none, settings, devotionalDetail, subscription }

class _AppShellState extends State<AppShell> {
  int _currentTab = 0;
  _OverlayScreen _overlayScreen = _OverlayScreen.none;
  int? _devotionalId;

  String? _bibleBook;
  int? _bibleChapter;

  void _switchTab(int index) {
    setState(() {
      _currentTab = index;
      _overlayScreen = _OverlayScreen.none;
    });
  }

  void _openDevotional(int id) {
    setState(() {
      _devotionalId = id;
      _overlayScreen = _OverlayScreen.devotionalDetail;
    });
  }

  void _openSettings() {
    setState(() => _overlayScreen = _OverlayScreen.settings);
  }

  void _openSubscription() {
    setState(() => _overlayScreen = _OverlayScreen.subscription);
  }

  void _openBibleChapter(String book, int chapter) {
    setState(() {
      _bibleBook = book;
      _bibleChapter = chapter;
      _currentTab = 2;
      _overlayScreen = _OverlayScreen.none;
    });
  }

  void _closeOverlay() {
    setState(() => _overlayScreen = _OverlayScreen.none);
  }

  @override
  Widget build(BuildContext context) {
    if (_overlayScreen == _OverlayScreen.settings) {
      return SettingsScreen(
        onBack: _closeOverlay,
        onOpenSubscription: _openSubscription,
      );
    }

    if (_overlayScreen == _OverlayScreen.devotionalDetail &&
        _devotionalId != null) {
      return DevotionalDetailScreen(
        devotionalId: _devotionalId!,
        apiService: widget.apiService,
        onBack: _closeOverlay,
      );
    }

    if (_overlayScreen == _OverlayScreen.subscription) {
      return SubscriptionScreen(onBack: _closeOverlay);
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: [
          HomeScreen(
            apiService: widget.apiService,
            onSwitchTab: _switchTab,
            onOpenDevotional: _openDevotional,
            onOpenSettings: _openSettings,
            onOpenBibleChapter: _openBibleChapter,
          ),
          ExploreScreen(
            apiService: widget.apiService,
            onOpenDevotional: _openDevotional,
          ),
          BibleScreen(
            key: ValueKey('bible_${_bibleBook}_$_bibleChapter'),
            apiService: widget.apiService,
            initialBook: _bibleBook,
            initialChapter: _bibleChapter,
          ),
          const FavoritesScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (index) {
            if (index == 2) {
              setState(() {
                _bibleBook = null;
                _bibleChapter = null;
              });
            }
            _switchTab(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.tint,
          unselectedItemColor: AppColors.tabIconDefault,
          selectedLabelStyle: AppTheme.interMedium(11),
          unselectedLabelStyle: AppTheme.interMedium(11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.home, size: 22),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.compass, size: 22),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.bookOpen, size: 22),
              label: 'Bible',
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.heart, size: 22),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}

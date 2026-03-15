import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _bibleVersion = 'KJV';
  bool _notificationsEnabled = true;
  String _notificationTime = '08:00';
  bool _isPremium = false;
  double _fontSize = 16.0;

  static const _storageKey = '@bible_settings';

  String get bibleVersion => _bibleVersion;
  bool get notificationsEnabled => _notificationsEnabled;
  String get notificationTime => _notificationTime;
  bool get isPremium => _isPremium;
  double get fontSize => _fontSize;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final parsed = jsonDecode(data) as Map<String, dynamic>;
        _bibleVersion = parsed['bibleVersion'] as String? ?? 'KJV';
        _notificationsEnabled =
            parsed['notificationsEnabled'] as bool? ?? true;
        _notificationTime = parsed['notificationTime'] as String? ?? '08:00';
        _isPremium = parsed['isPremium'] as bool? ?? false;
        _fontSize = (parsed['fontSize'] as num?)?.toDouble() ?? 16.0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('SettingsProvider: failed to load settings: $e');
    }
  }

  Future<void> _persistSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode({
          'bibleVersion': _bibleVersion,
          'notificationsEnabled': _notificationsEnabled,
          'notificationTime': _notificationTime,
          'isPremium': _isPremium,
          'fontSize': _fontSize,
        }),
      );
    } catch (e) {
      debugPrint('SettingsProvider: failed to persist settings: $e');
    }
  }

  void updateSettings({
    String? bibleVersion,
    bool? notificationsEnabled,
    String? notificationTime,
    bool? isPremium,
    double? fontSize,
  }) {
    if (bibleVersion != null) _bibleVersion = bibleVersion;
    if (notificationsEnabled != null) {
      _notificationsEnabled = notificationsEnabled;
    }
    if (notificationTime != null) _notificationTime = notificationTime;
    if (isPremium != null) _isPremium = isPremium;
    if (fontSize != null) _fontSize = fontSize;
    notifyListeners();
    _persistSettings();
  }
}

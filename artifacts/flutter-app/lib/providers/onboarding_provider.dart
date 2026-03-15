import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  bool? _hasCompletedOnboarding;
  static const _storageKey = '@bible_onboarding_done';

  bool? get hasCompletedOnboarding => _hasCompletedOnboarding;

  OnboardingProvider() {
    _loadOnboardingState();
  }

  Future<void> _loadOnboardingState() async {
    bool resolved = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_storageKey);
      resolved = true;
      _hasCompletedOnboarding = value == 'true';
      notifyListeners();
    } catch (_) {
      if (!resolved) {
        _hasCompletedOnboarding = false;
        notifyListeners();
      }
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (_hasCompletedOnboarding == null) {
        _hasCompletedOnboarding = false;
        notifyListeners();
      }
    });
  }

  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, 'true');
    } catch (_) {}
  }
}

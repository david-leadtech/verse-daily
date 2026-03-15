import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_verse.dart';

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteVerse> _favorites = [];
  static const _storageKey = '@bible_favorites';

  List<FavoriteVerse> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null) {
        final parsed = jsonDecode(data) as List;
        _favorites =
            parsed.map((e) => FavoriteVerse.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('FavoritesProvider: failed to load favorites: $e');
    }
  }

  Future<void> _persistFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode(_favorites.map((f) => f.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('FavoritesProvider: failed to persist favorites: $e');
    }
  }

  bool isFavorite(int verseId) {
    return _favorites.any((f) => f.id == verseId);
  }

  void toggleFavorite({
    required int id,
    required String book,
    required int chapter,
    required int verseNumber,
    required String text,
    required String version,
  }) {
    final exists = _favorites.any((f) => f.id == id);
    if (exists) {
      _favorites.removeWhere((f) => f.id == id);
    } else {
      _favorites.insert(
        0,
        FavoriteVerse(
          id: id,
          book: book,
          chapter: chapter,
          verseNumber: verseNumber,
          text: text,
          version: version,
          savedAt: DateTime.now().toIso8601String(),
        ),
      );
    }
    notifyListeners();
    _persistFavorites();
  }

  void removeFavorite(int verseId) {
    _favorites.removeWhere((f) => f.id == verseId);
    notifyListeners();
    _persistFavorites();
  }
}

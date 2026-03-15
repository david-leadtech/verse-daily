import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verse.dart';
import '../models/devotional.dart';
import '../models/book.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<DailyVerseResponse> getDailyVerse() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/verses/daily'));
    if (response.statusCode == 200) {
      return DailyVerseResponse.fromJson(jsonDecode(response.body));
    }
    throw ApiException('Failed to load daily verse', response.statusCode);
  }

  Future<VersesResponse> getVerses({
    String? book,
    int? chapter,
    int limit = 100,
  }) async {
    final params = <String, String>{};
    if (book != null) params['book'] = book;
    if (chapter != null) params['chapter'] = chapter.toString();
    params['limit'] = limit.toString();

    final uri = Uri.parse('$baseUrl/api/verses').replace(queryParameters: params);
    final response = await _client.get(uri);
    if (response.statusCode == 200) {
      return VersesResponse.fromJson(jsonDecode(response.body));
    }
    throw ApiException('Failed to load verses', response.statusCode);
  }

  Future<BooksResponse> getBooks() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/books'));
    if (response.statusCode == 200) {
      return BooksResponse.fromJson(jsonDecode(response.body));
    }
    throw ApiException('Failed to load books', response.statusCode);
  }

  Future<DevotionalsResponse> getDevotionals({
    String? category,
    int limit = 20,
  }) async {
    final params = <String, String>{};
    if (category != null) params['category'] = category;
    params['limit'] = limit.toString();

    final uri =
        Uri.parse('$baseUrl/api/devotionals').replace(queryParameters: params);
    final response = await _client.get(uri);
    if (response.statusCode == 200) {
      return DevotionalsResponse.fromJson(jsonDecode(response.body));
    }
    throw ApiException('Failed to load devotionals', response.statusCode);
  }

  Future<Devotional> getDevotional(int id) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/devotionals/$id'));
    if (response.statusCode == 200) {
      return Devotional.fromJson(jsonDecode(response.body));
    }
    throw ApiException('Failed to load devotional', response.statusCode);
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

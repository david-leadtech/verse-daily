class FavoriteVerse {
  final int id;
  final String book;
  final int chapter;
  final int verseNumber;
  final String text;
  final String version;
  final String savedAt;

  const FavoriteVerse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verseNumber,
    required this.text,
    required this.version,
    required this.savedAt,
  });

  factory FavoriteVerse.fromJson(Map<String, dynamic> json) {
    return FavoriteVerse(
      id: json['id'] as int,
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      verseNumber: json['verseNumber'] as int,
      text: json['text'] as String,
      version: json['version'] as String? ?? 'KJV',
      savedAt: json['savedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book': book,
      'chapter': chapter,
      'verseNumber': verseNumber,
      'text': text,
      'version': version,
      'savedAt': savedAt,
    };
  }
}

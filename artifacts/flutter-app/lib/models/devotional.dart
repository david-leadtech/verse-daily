class Devotional {
  final int id;
  final String title;
  final String category;
  final int readTime;
  final String verseReference;
  final String verseText;
  final String content;

  const Devotional({
    required this.id,
    required this.title,
    required this.category,
    required this.readTime,
    required this.verseReference,
    required this.verseText,
    required this.content,
  });

  factory Devotional.fromJson(Map<String, dynamic> json) {
    return Devotional(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String? ?? 'Faith',
      readTime: json['readTime'] as int? ?? 5,
      verseReference: json['verseReference'] as String? ?? '',
      verseText: json['verseText'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }
}

class DevotionalsResponse {
  final List<Devotional> devotionals;

  const DevotionalsResponse({required this.devotionals});

  factory DevotionalsResponse.fromJson(Map<String, dynamic> json) {
    return DevotionalsResponse(
      devotionals: (json['devotionals'] as List?)
              ?.map((d) => Devotional.fromJson(d))
              .toList() ??
          [],
    );
  }
}

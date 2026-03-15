class Verse {
  final int id;
  final String book;
  final int chapter;
  final int verseNumber;
  final String text;
  final String version;

  const Verse({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verseNumber,
    required this.text,
    required this.version,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] as int,
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      verseNumber: json['verseNumber'] as int,
      text: json['text'] as String,
      version: json['version'] as String? ?? 'KJV',
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
    };
  }
}

class DailyVerseResponse {
  final Verse? verse;
  final String? reflection;

  const DailyVerseResponse({this.verse, this.reflection});

  factory DailyVerseResponse.fromJson(Map<String, dynamic> json) {
    return DailyVerseResponse(
      verse: json['verse'] != null ? Verse.fromJson(json['verse']) : null,
      reflection: json['reflection'] as String?,
    );
  }
}

class VersesResponse {
  final List<Verse> verses;
  final int total;

  const VersesResponse({required this.verses, required this.total});

  factory VersesResponse.fromJson(Map<String, dynamic> json) {
    return VersesResponse(
      verses: (json['verses'] as List?)
              ?.map((v) => Verse.fromJson(v))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
    );
  }
}

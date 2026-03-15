class BibleBook {
  final String name;
  final int chapters;
  final String testament;

  const BibleBook({
    required this.name,
    required this.chapters,
    required this.testament,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      name: json['name'] as String,
      chapters: json['chapters'] as int? ?? 1,
      testament: json['testament'] as String? ?? 'Old Testament',
    );
  }
}

class BooksResponse {
  final List<BibleBook> books;

  const BooksResponse({required this.books});

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    return BooksResponse(
      books: (json['books'] as List?)
              ?.map((b) => BibleBook.fromJson(b))
              .toList() ??
          [],
    );
  }
}

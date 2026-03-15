import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/book.dart';
import '../models/verse.dart';
import '../widgets/verse_card.dart';

class BibleScreen extends StatefulWidget {
  final ApiService apiService;
  final String? initialBook;
  final int? initialChapter;

  const BibleScreen({
    super.key,
    required this.apiService,
    this.initialBook,
    this.initialChapter,
  });

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  String _selectedBook = '';
  int _selectedChapter = 0;
  bool _showBookPicker = true;

  List<BibleBook> _books = [];
  List<Verse> _verses = [];
  bool _versesLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialBook != null) {
      _selectedBook = widget.initialBook!;
      _showBookPicker = false;
      if (widget.initialChapter != null) {
        _selectedChapter = widget.initialChapter!;
        _loadVerses();
      }
    }
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final data = await widget.apiService.getBooks();
      if (mounted) setState(() => _books = data.books);
    } catch (_) {}
  }

  Future<void> _loadVerses() async {
    if (_selectedBook.isEmpty || _selectedChapter == 0) return;
    setState(() => _versesLoading = true);
    try {
      final data = await widget.apiService.getVerses(
        book: _selectedBook,
        chapter: _selectedChapter,
        limit: 100,
      );
      if (mounted) setState(() {
        _verses = data.verses;
        _versesLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _versesLoading = false);
    }
  }

  void _selectBook(String bookName) {
    setState(() {
      _selectedBook = bookName;
      _selectedChapter = 0;
      _showBookPicker = false;
    });
  }

  void _selectChapter(int chapter) {
    setState(() => _selectedChapter = chapter);
    _loadVerses();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    if (_showBookPicker) {
      return _buildBookPicker(topPadding);
    }

    if (_selectedBook.isNotEmpty && _selectedChapter == 0) {
      return _buildChapterPicker(topPadding);
    }

    return _buildReader(topPadding);
  }

  Widget _buildBookPicker(double topPadding) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                Text('Select a Book', style: AppTheme.playfairBold(24)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                final isOT = book.testament == 'Old Testament';
                return GestureDetector(
                  onTap: () => _selectBook(book.name),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.borderLight),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (isOT ? AppColors.accent : AppColors.tint)
                                .withOpacity(0.12),
                          ),
                          child: Center(
                            child: Text(
                              isOT ? 'OT' : 'NT',
                              style: AppTheme.interBold(12).copyWith(
                                color:
                                    isOT ? AppColors.accent : AppColors.tint,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.name,
                                  style: AppTheme.interMedium(16)),
                              const SizedBox(height: 2),
                              Text(
                                '${book.chapters} chapters',
                                style: AppTheme.interRegular(13).copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(FeatherIcons.chevronRight,
                            size: 18, color: AppColors.tabIconDefault),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterPicker(double topPadding) {
    final bookData = _books.firstWhere(
      (b) => b.name == _selectedBook,
      orElse: () => BibleBook(name: _selectedBook, chapters: 1, testament: ''),
    );
    final chapters = List.generate(bookData.chapters, (i) => i + 1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _showBookPicker = true),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(FeatherIcons.chevronLeft,
                        size: 24, color: AppColors.tint),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedBook,
                          style: AppTheme.playfairBold(24)),
                      const SizedBox(height: 2),
                      Text(
                        'Select a chapter',
                        style: AppTheme.interRegular(14).copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: chapters.map((ch) {
                  return GestureDetector(
                    onTap: () => _selectChapter(ch),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: Text(
                          '$ch',
                          style: AppTheme.playfairBold(18),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReader(double topPadding) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 12),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                bottom: BorderSide(color: AppColors.borderLight),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedChapter = 0),
                  child: const Icon(FeatherIcons.chevronLeft,
                      size: 24, color: AppColors.tint),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_selectedBook $_selectedChapter',
                      style: AppTheme.playfairBold(18),
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
          if (_versesLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              ),
            )
          else if (_verses.isNotEmpty)
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                itemCount: _verses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final verse = _verses[index];
                  return VerseCard(
                    id: verse.id,
                    book: verse.book,
                    chapter: verse.chapter,
                    verseNumber: verse.verseNumber,
                    text: verse.text,
                    version: verse.version,
                    gradientIndex: index % 8,
                    compact: true,
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(FeatherIcons.book,
                        size: 48, color: AppColors.tabIconDefault),
                    const SizedBox(height: 12),
                    Text('No verses found',
                        style: AppTheme.playfairBold(18)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'This chapter doesn\'t have any verses in our collection yet.',
                        textAlign: TextAlign.center,
                        style: AppTheme.interRegular(14).copyWith(
                          color: AppColors.textSecondary,
                          height: 1.571,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

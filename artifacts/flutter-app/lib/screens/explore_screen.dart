import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import '../theme/colors.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/devotional.dart';
import '../widgets/devotional_card.dart';

const _categories = [
  'All', 'Peace', 'Strength', 'Faith', 'Gratitude',
  'Love', 'Trust', 'Growth', 'Rest', 'Courage',
];

class ExploreScreen extends StatefulWidget {
  final ApiService apiService;
  final void Function(int devotionalId) onOpenDevotional;

  const ExploreScreen({
    super.key,
    required this.apiService,
    required this.onOpenDevotional,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<Devotional> _devotionals = [];
  bool _loading = true;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadDevotionals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadDevotionals() async {
    setState(() => _loading = true);
    try {
      final data = await widget.apiService.getDevotionals(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        limit: 20,
      );
      if (mounted) setState(() {
        _devotionals = data.devotionals;
        _loading = false;
      });
    } catch (e) {
      debugPrint('ExploreScreen: failed to load devotionals: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _loadDevotionals();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<Devotional> get _filteredDevotionals {
    if (_searchQuery.isEmpty) return _devotionals;
    return _devotionals.where((dev) {
      return dev.title.toLowerCase().contains(_searchQuery) ||
          dev.category.toLowerCase().contains(_searchQuery) ||
          dev.verseReference.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final filtered = _filteredDevotionals;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: EdgeInsets.only(
          top: topPadding + 16,
          bottom: 100,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Devotionals', style: AppTheme.playfairBold(28)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text(
              'Daily reflections to deepen your faith',
              style: AppTheme.playfairItalic(14).copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                style: AppTheme.interRegular(15),
                decoration: InputDecoration(
                  hintText: 'Search devotionals...',
                  hintStyle: AppTheme.interRegular(15).copyWith(
                    color: AppColors.tabIconDefault,
                  ),
                  prefixIcon: const Icon(
                    FeatherIcons.search,
                    size: 18,
                    color: AppColors.tabIconDefault,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _onSearchChanged('');
                            _searchFocusNode.unfocus();
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            size: 18,
                            color: AppColors.tabIconDefault,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isActive = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => _selectCategory(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.tint
                          : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? AppColors.tint : AppColors.border,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: AppTheme.interMedium(14).copyWith(
                        color: isActive
                            ? const Color(0xFFF5ECD7)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_loading)
            const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              ),
            )
          else if (filtered.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: filtered
                    .map(
                      (dev) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DevotionalCard(
                          id: dev.id,
                          title: dev.title,
                          category: dev.category,
                          readTime: dev.readTime,
                          verseReference: dev.verseReference,
                          onPress: () => widget.onOpenDevotional(dev.id),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  const Icon(FeatherIcons.bookOpen,
                      size: 48, color: AppColors.tabIconDefault),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No results found'
                        : 'No devotionals found',
                    style: AppTheme.playfairBold(18),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'Try a different search term or browse by category.'
                          : _selectedCategory != 'All'
                              ? 'No devotionals in the "$_selectedCategory" category yet.'
                              : 'Check back soon for new devotionals.',
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
        ],
      ),
    );
  }
}

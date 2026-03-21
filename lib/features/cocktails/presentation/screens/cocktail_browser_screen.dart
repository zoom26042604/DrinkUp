import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../providers/cocktail_providers.dart';
import '../providers/nav_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'cocktail_detail_screen.dart';

class CocktailBrowserScreen extends ConsumerStatefulWidget {
  const CocktailBrowserScreen({super.key});

  @override
  ConsumerState<CocktailBrowserScreen> createState() =>
      _CocktailBrowserScreenState();
}

class _CocktailBrowserScreenState
    extends ConsumerState<CocktailBrowserScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final q = _searchController.text.trim();
      setState(() => _query = q);
      ref.read(searchQueryProvider.notifier).state = q;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.beigeFonce, AppColors.rose],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: BottomNavBar(
          currentIndex: ref.watch(navIndexProvider),
          onTap: (i) {
            ref.read(navIndexProvider.notifier).state = i;
            Navigator.pop(context);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.noir),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'All Cocktails',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.noir,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.beige,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.rose, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset(
                          'assets/images/search.png',
                          width: 22,
                          height: 22,
                          color: AppColors.noir,
                          colorBlendMode: BlendMode.srcIn,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                              color: AppColors.noir, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search a cocktail...',
                            hintStyle: TextStyle(
                                color: AppColors.noir.withValues(alpha: 0.4),
                                fontSize: 14),
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                      if (_query.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.noir, size: 18),
                          onPressed: () => _searchController.clear(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(child: _query.isEmpty ? _buildLetterBrowser() : _buildSearchResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBrowser() {
    final letters = List.generate(26, (i) => String.fromCharCode(65 + i));
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: letters.map((letter) {
        return _LetterSection(letter: letter);
      }).toList(),
    );
  }

  Widget _buildSearchResults() {
    final resultsAsync = ref.watch(searchResultsProvider);
    return resultsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.noir)),
      error: (_, _) => const Center(
          child: Text('Something went wrong',
              style: TextStyle(color: AppColors.noir))),
      data: (cocktails) {
        if (cocktails.isEmpty) {
          return Center(
            child: Text(
              'No results for "$_query"',
              style: TextStyle(
                  color: AppColors.noir.withValues(alpha: 0.6), fontSize: 14),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          itemCount: cocktails.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _CocktailTile(cocktail: cocktails[i]),
        );
      },
    );
  }
}

class _LetterSection extends ConsumerWidget {
  final String letter;
  const _LetterSection({required this.letter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync =
        ref.watch(cocktailsByLetterProvider(letter.toLowerCase()));
    return resultsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (cocktails) {
        if (cocktails.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.noir,
                ),
              ),
            ),
            ...cocktails.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _CocktailTile(cocktail: c),
                )),
          ],
        );
      },
    );
  }
}

class _CocktailTile extends StatelessWidget {
  final dynamic cocktail;
  const _CocktailTile({required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CocktailDetailScreen(cocktail: cocktail)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.rose, width: 1.5),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: cocktail.thumbnailUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.rose.withValues(alpha: 0.2),
                ),
                errorWidget: (_, _, _) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.rose.withValues(alpha: 0.2),
                  child: const Icon(Icons.local_bar, color: AppColors.rose),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cocktail.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.noir,
                    ),
                  ),
                  if (cocktail.category != null)
                    Text(
                      cocktail.category!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.noir.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

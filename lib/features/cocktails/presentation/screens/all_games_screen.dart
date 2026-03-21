import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../providers/game_favorites_provider.dart';
import '../providers/nav_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'guess_demon_liquid_screen.dart';
import 'guess_my_cocktail.dart';
import 'is_it_in_my_cocktail.dart';
import 'is_your_memory_wasted.dart';

class _GameEntry {
  final int index;
  final String title;
  final String desc;
  final Widget screen;
  const _GameEntry({required this.index, required this.title, required this.desc, required this.screen});
}

final _allGames = [
  _GameEntry(index: 0, title: 'Guess My Cocktail', desc: 'Ingredients revealed one by one — name the cocktail!', screen: const GuessMyCocktailScreen()),
  _GameEntry(index: 1, title: 'Guess My Demon Liquid', desc: 'See the cocktail, find the alcohol hiding inside!', screen: const GuessDemonLiquidScreen()),
  _GameEntry(index: 2, title: 'Is It In My Cocktail?', desc: 'Drag and drop ingredients to sort what is in or not!', screen: const IsItInMyCocktailScreen()),
  _GameEntry(index: 3, title: 'Is Your Memory Wasted?', desc: 'Flip cards and match cocktail pairs before time\'s up!', screen: const IsYourMemoryWastedScreen()),
];

class AllGamesScreen extends ConsumerStatefulWidget {
  const AllGamesScreen({super.key});

  @override
  ConsumerState<AllGamesScreen> createState() => _AllGamesScreenState();
}

class _AllGamesScreenState extends ConsumerState<AllGamesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _allGames
        : _allGames.where((g) => g.title.toLowerCase().contains(_query)).toList();

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
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.noir),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'All Games',
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
                          style: const TextStyle(color: AppColors.noir, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search a game...',
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
              const SizedBox(height: 16),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No game matching "$_query"',
                          style: TextStyle(
                            color: AppColors.noir.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final game = filtered[i];
                          final isFav = ref.watch(gameFavoritesProvider).contains(game.index);
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => game.screen),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.beige,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.rose, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 4),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          game.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.noir,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          game.desc,
                                          style: const TextStyle(
                                              fontSize: 11, color: AppColors.noir),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFav ? Icons.star_rounded : Icons.star_border_rounded,
                                      color: isFav ? AppColors.rose : AppColors.noir,
                                      size: 28,
                                    ),
                                    onPressed: () => ref
                                        .read(gameFavoritesProvider.notifier)
                                        .toggle(game.index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

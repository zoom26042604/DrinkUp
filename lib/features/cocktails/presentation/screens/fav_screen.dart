import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/register_screen.dart';
import '../providers/cocktail_providers.dart';
import '../providers/game_favorites_provider.dart';
import 'cocktail_browser_screen.dart';
import 'cocktail_detail_screen.dart';
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

class FavScreen extends ConsumerStatefulWidget {
  const FavScreen({super.key});

  @override
  ConsumerState<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends ConsumerState<FavScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.beigeFonce, AppColors.rose],
        ),
      ),
      child: SafeArea(
        child: authAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: AppColors.noir)),
          error: (_, _) => const Center(
              child: Text('Error', style: TextStyle(color: AppColors.noir))),
          data: (user) =>
              user == null ? _buildGuestView(context) : _buildMemberView(),
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_rounded,
                size: 64, color: AppColors.noir.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            const Text(
              'Members only',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.noir,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sign in or create an account to save your favourite cocktails and games.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.noir.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 28),
            _AuthButton(
              label: 'Sign in',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen())),
            ),
            const SizedBox(height: 12),
            _AuthButton(
              label: 'Create an account',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'My Favourites',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.noir,
            ),
          ),
        ),
        const SizedBox(height: 14),
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
                      hintText: 'Search...',
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
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.noir,
          dividerColor: Colors.transparent,
          labelColor: AppColors.noir,
          unselectedLabelColor: AppColors.noir.withValues(alpha: 0.45),
          labelStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Cocktails'),
            Tab(text: 'Games'),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCocktailsTab(),
              _buildGamesTab(),
            ],
          ),
        ),
        ],
        ),
        if (_tabController.index == 0)
        Positioned(
          bottom: 0,
          right: 24,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CocktailBrowserScreen()),
            ),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.beige,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.noir, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Center(
                child: Image.asset('assets/images/plus.png', width: 24, height: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCocktailsTab() {
    final favAsync = ref.watch(favoritesProvider);
    return favAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.noir)),
      error: (_, _) => const Center(
          child: Text('Could not load favourites',
              style: TextStyle(color: AppColors.noir))),
      data: (cocktails) {
        final filtered = _query.isEmpty
            ? cocktails
            : cocktails
                .where((c) => c.name.toLowerCase().contains(_query))
                .toList();
        if (filtered.isEmpty) {
          return _buildEmpty(
            _query.isNotEmpty
                ? 'No cocktail matching "$_query"'
                : 'No favourite cocktails yet\nPlay games and save cocktails you like!',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          itemCount: filtered.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final cocktail = filtered[i];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CocktailDetailScreen(cocktail: cocktail)),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.beige,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.rose, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: cocktail.thumbnailUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 64,
                          height: 64,
                          color: AppColors.rose.withValues(alpha: 0.2),
                        ),
                        errorWidget: (_, _, _) => Container(
                          width: 64,
                          height: 64,
                          color: AppColors.rose.withValues(alpha: 0.2),
                          child: const Icon(Icons.local_bar,
                              color: AppColors.rose),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cocktail.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.noir,
                            ),
                          ),
                          if (cocktail.category != null)
                            Text(
                              cocktail.category!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.noir.withValues(alpha: 0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.star_rounded,
                          color: AppColors.rose, size: 36),
                      onPressed: () => ref
                          .read(favoritesProvider.notifier)
                          .toggle(cocktail),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGamesTab() {
    final favGames = ref.watch(gameFavoritesProvider);
    final favoriteEntries =
        _allGames.where((g) => favGames.contains(g.index)).toList();
    final filtered = _query.isEmpty
        ? favoriteEntries
        : favoriteEntries
            .where((g) => g.title.toLowerCase().contains(_query))
            .toList();

    if (filtered.isEmpty) {
      return _buildEmpty(
        _query.isNotEmpty
            ? 'No game matching "$_query"'
            : 'No favourite games yet\nTap the star icon in a game to save it!',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final game = filtered[i];
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
                  icon: const Icon(Icons.star_rounded,
                      color: AppColors.rose, size: 36),
                  onPressed: () =>
                      ref.read(gameFavoritesProvider.notifier).toggle(game.index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.noir.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AuthButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.rose, width: 2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.noir,
          ),
        ),
      ),
    );
  }
}

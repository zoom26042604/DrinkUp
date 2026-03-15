import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cocktails/presentation/screens/cocktail_detail_screen.dart';
import '../../features/cocktails/presentation/screens/favorites_screen.dart';
import '../../features/cocktails/presentation/screens/home_screen.dart';
import '../../features/cocktails/presentation/screens/search_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/', builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/favorites',
                  builder: (_, _) => const FavoritesScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/cocktail/:id',
        builder: (_, state) =>
            CocktailDetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
});

class _MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainScaffold({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Recherche'),
          NavigationDestination(
              icon: Icon(Icons.favorite), label: 'Favoris'),
        ],
      ),
    );
  }
}

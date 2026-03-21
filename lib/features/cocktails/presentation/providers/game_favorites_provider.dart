import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/app_providers.dart';

class GameFavoritesNotifier extends Notifier<Set<int>> {
  static const _key = 'game_favorites';

  @override
  Set<int> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getStringList(_key) ?? [];
    return stored.map(int.parse).toSet();
  }

  void toggle(int index) {
    final prefs = ref.read(sharedPreferencesProvider);
    final next = Set<int>.from(state);
    if (next.contains(index)) {
      next.remove(index);
    } else {
      next.add(index);
    }
    prefs.setStringList(_key, next.map((i) => i.toString()).toList());
    state = next;
  }

  bool isFavorite(int index) => state.contains(index);
}

final gameFavoritesProvider =
    NotifierProvider<GameFavoritesNotifier, Set<int>>(
  GameFavoritesNotifier.new,
);

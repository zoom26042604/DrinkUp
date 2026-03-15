import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/providers/app_providers.dart';
import '../../domain/entities/cocktail.dart';

final selectedLetterProvider = StateProvider<String>((ref) => 'a');

final cocktailsByLetterProvider = FutureProvider.family<List<Cocktail>, String>(
  (ref, letter) async {
    final repo = ref.watch(cocktailRepositoryProvider);
    final result = await repo.searchByFirstLetter(letter);
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw failure,
    };
  },
);

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Cocktail>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  final usecase = ref.watch(searchCocktailsUsecaseProvider);
  final result = await usecase(query);
  return switch (result) {
    ApiSuccess(:final data) => data,
    ApiError(:final failure) => throw failure,
  };
});

final cocktailDetailProvider = FutureProvider.family<Cocktail, String>(
  (ref, id) async {
    final usecase = ref.watch(getCocktailDetailUsecaseProvider);
    final result = await usecase(id);
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw failure,
    };
  },
);

class FavoritesNotifier extends AsyncNotifier<List<Cocktail>> {
  @override
  Future<List<Cocktail>> build() async {
    final usecase = ref.watch(getFavoritesUsecaseProvider);
    final result = await usecase();
    return switch (result) {
      ApiSuccess(:final data) => data,
      ApiError(:final failure) => throw failure,
    };
  }

  Future<void> toggle(Cocktail cocktail) async {
    final usecase = ref.read(toggleFavoriteUsecaseProvider);
    await usecase(cocktail);
    ref.invalidateSelf();
  }

  bool isFavorite(String id) {
    return state.valueOrNull?.any((c) => c.id == id) ?? false;
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Cocktail>>(
  FavoritesNotifier.new,
);

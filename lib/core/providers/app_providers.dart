import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../../features/cocktails/data/datasources/cocktail_local_datasource.dart';
import '../../features/cocktails/data/datasources/cocktail_remote_datasource.dart';
import '../../features/cocktails/data/repositories/cocktail_repository_impl.dart';
import '../../features/cocktails/domain/repositories/cocktail_repository.dart';
import '../../features/cocktails/domain/usecases/filter_cocktails.dart';
import '../../features/cocktails/domain/usecases/get_categories.dart';
import '../../features/cocktails/domain/usecases/get_cocktail_detail.dart';
import '../../features/cocktails/domain/usecases/get_favorites.dart';
import '../../features/cocktails/domain/usecases/get_random_cocktail.dart';
import '../../features/cocktails/domain/usecases/search_cocktails.dart';
import '../../features/cocktails/domain/usecases/toggle_favorite.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final dioProvider = Provider<Dio>((ref) => DioClient.create());

final remoteDatasourceProvider = Provider<CocktailRemoteDatasource>(
  (ref) => CocktailRemoteDatasourceImpl(ref.watch(dioProvider)),
);

final localDatasourceProvider = Provider<CocktailLocalDatasource>(
  (ref) => CocktailLocalDatasourceImpl(ref.watch(sharedPreferencesProvider)),
);

final cocktailRepositoryProvider = Provider<CocktailRepository>(
  (ref) => CocktailRepositoryImpl(
    ref.watch(remoteDatasourceProvider),
    ref.watch(localDatasourceProvider),
  ),
);

final searchCocktailsUsecaseProvider = Provider<SearchCocktails>(
  (ref) => SearchCocktails(ref.watch(cocktailRepositoryProvider)),
);

final getCocktailDetailUsecaseProvider = Provider<GetCocktailDetail>(
  (ref) => GetCocktailDetail(ref.watch(cocktailRepositoryProvider)),
);

final getRandomCocktailUsecaseProvider = Provider<GetRandomCocktail>(
  (ref) => GetRandomCocktail(ref.watch(cocktailRepositoryProvider)),
);

final filterCocktailsUsecaseProvider = Provider<FilterCocktails>(
  (ref) => FilterCocktails(ref.watch(cocktailRepositoryProvider)),
);

final getCategoriesUsecaseProvider = Provider<GetCategories>(
  (ref) => GetCategories(ref.watch(cocktailRepositoryProvider)),
);

final getFavoritesUsecaseProvider = Provider<GetFavorites>(
  (ref) => GetFavorites(ref.watch(cocktailRepositoryProvider)),
);

final toggleFavoriteUsecaseProvider = Provider<ToggleFavorite>(
  (ref) => ToggleFavorite(ref.watch(cocktailRepositoryProvider)),
);

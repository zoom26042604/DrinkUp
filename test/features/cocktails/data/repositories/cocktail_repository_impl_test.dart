import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:drinkup/core/errors/exceptions.dart';
import 'package:drinkup/core/errors/failures.dart';
import 'package:drinkup/core/network/api_result.dart';
import 'package:drinkup/features/cocktails/data/datasources/cocktail_local_datasource.dart';
import 'package:drinkup/features/cocktails/data/datasources/cocktail_remote_datasource.dart';
import 'package:drinkup/features/cocktails/data/models/cocktail_model.dart';
import 'package:drinkup/features/cocktails/data/repositories/cocktail_repository_impl.dart';

class MockRemote extends Mock implements CocktailRemoteDatasource {}
class MockLocal extends Mock implements CocktailLocalDatasource {}

const tCocktailModel = CocktailModel(
  id: '11007',
  name: 'Margarita',
  category: 'Ordinary Drink',
  isAlcoholic: true,
  glassType: 'Cocktail glass',
  thumbnailUrl: 'https://example.com/thumb.jpg',
  ingredients: [],
);

void main() {
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late CocktailRepositoryImpl repository;

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    repository = CocktailRepositoryImpl(mockRemote, mockLocal);
  });

  group('searchByName', () {
    test('returns ApiSuccess with cocktail list on success', () async {
      when(() => mockRemote.searchByName(any()))
          .thenAnswer((_) async => [tCocktailModel]);

      final result = await repository.searchByName('margarita');

      expect(result, isA<ApiSuccess<List>>());
      expect((result as ApiSuccess).data.first.name, 'Margarita');
    });

    test('returns ApiError(NotFoundFailure) when NotFoundException', () async {
      when(() => mockRemote.searchByName(any()))
          .thenThrow(const NotFoundException());

      final result = await repository.searchByName('unknown');

      expect(result, isA<ApiError>());
      expect((result as ApiError).failure, isA<NotFoundFailure>());
    });

    test('returns ApiError(CacheFailure) when CacheException on favorites',
        () async {
      when(() => mockLocal.getFavorites()).thenThrow(const CacheException());

      final result = await repository.getFavorites();

      expect(result, isA<ApiError>());
      expect((result as ApiError).failure, isA<CacheFailure>());
    });
  });

  group('toggleFavorite', () {
    test('returns true when cocktail is added to favorites', () async {
      when(() => mockLocal.isFavorite(any())).thenAnswer((_) async => false);
      when(() => mockLocal.saveFavorite(any())).thenAnswer((_) async {});

      final result = await repository.toggleFavorite(tCocktailModel);

      expect((result as ApiSuccess).data, true);
      verify(() => mockLocal.saveFavorite(tCocktailModel)).called(1);
    });

    test('returns false when cocktail is removed from favorites', () async {
      when(() => mockLocal.isFavorite(any())).thenAnswer((_) async => true);
      when(() => mockLocal.removeFavorite(any())).thenAnswer((_) async {});

      final result = await repository.toggleFavorite(tCocktailModel);

      expect((result as ApiSuccess).data, false);
      verify(() => mockLocal.removeFavorite(tCocktailModel.id)).called(1);
    });
  });
}

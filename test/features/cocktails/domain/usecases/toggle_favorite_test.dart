import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:drinkup/core/errors/failures.dart';
import 'package:drinkup/core/network/api_result.dart';
import 'package:drinkup/features/cocktails/domain/entities/cocktail.dart';
import 'package:drinkup/features/cocktails/domain/repositories/cocktail_repository.dart';
import 'package:drinkup/features/cocktails/domain/usecases/toggle_favorite.dart';

class MockCocktailRepository extends Mock implements CocktailRepository {}

const tCocktail = Cocktail(
  id: '11007',
  name: 'Margarita',
  isAlcoholic: true,
  thumbnailUrl: 'https://example.com/thumb.jpg',
  ingredients: [],
);

void main() {
  late MockCocktailRepository mockRepository;
  late ToggleFavorite usecase;

  setUp(() {
    mockRepository = MockCocktailRepository();
    usecase = ToggleFavorite(mockRepository);
  });

  test('returns true when cocktail is added to favorites', () async {
    when(() => mockRepository.toggleFavorite(any()))
        .thenAnswer((_) async => const ApiSuccess(true));

    final result = await usecase(tCocktail);

    expect((result as ApiSuccess).data, true);
  });

  test('returns false when cocktail is removed from favorites', () async {
    when(() => mockRepository.toggleFavorite(any()))
        .thenAnswer((_) async => const ApiSuccess(false));

    final result = await usecase(tCocktail);

    expect((result as ApiSuccess).data, false);
  });

  test('propagates CacheFailure from repository', () async {
    when(() => mockRepository.toggleFavorite(any()))
        .thenAnswer((_) async => const ApiError(CacheFailure()));

    final result = await usecase(tCocktail);

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<CacheFailure>());
  });
}

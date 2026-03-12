import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:drinkup/core/errors/failures.dart';
import 'package:drinkup/core/network/api_result.dart';
import 'package:drinkup/features/cocktails/domain/entities/ingredient_detail.dart';
import 'package:drinkup/features/cocktails/domain/repositories/cocktail_repository.dart';
import 'package:drinkup/features/cocktails/domain/usecases/search_ingredient_by_name.dart';

class MockCocktailRepository extends Mock implements CocktailRepository {}

const tIngredient = IngredientDetail(
  id: '1',
  name: 'Vodka',
  type: 'Vodka',
  isAlcoholic: true,
  abv: '40',
  imageSmallUrl: 'https://example.com/vodka-small.png',
  imageMediumUrl: 'https://example.com/vodka-medium.png',
  imageLargeUrl: 'https://example.com/vodka.png',
);

void main() {
  late MockCocktailRepository mockRepository;
  late SearchIngredientByName usecase;

  setUp(() {
    mockRepository = MockCocktailRepository();
    usecase = SearchIngredientByName(mockRepository);
  });

  test('returns ApiSuccess with ingredient list on valid query', () async {
    when(() => mockRepository.searchIngredientByName(any()))
        .thenAnswer((_) async => const ApiSuccess([tIngredient]));

    final result = await usecase('vodka');

    expect(result, isA<ApiSuccess<List<IngredientDetail>>>());
    expect((result as ApiSuccess).data.first.name, 'Vodka');
    verify(() => mockRepository.searchIngredientByName('vodka')).called(1);
  });

  test('returns ValidationFailure when query is empty', () async {
    final result = await usecase('');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<ValidationFailure>());
    verifyNever(() => mockRepository.searchIngredientByName(any()));
  });

  test('returns ValidationFailure when query is only whitespace', () async {
    final result = await usecase('   ');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<ValidationFailure>());
    verifyNever(() => mockRepository.searchIngredientByName(any()));
  });

  test('trims query before calling repository', () async {
    when(() => mockRepository.searchIngredientByName(any()))
        .thenAnswer((_) async => const ApiSuccess([tIngredient]));

    await usecase('  vodka  ');

    verify(() => mockRepository.searchIngredientByName('vodka')).called(1);
  });

  test('propagates repository failure', () async {
    when(() => mockRepository.searchIngredientByName(any()))
        .thenAnswer((_) async => const ApiError(NotFoundFailure()));

    final result = await usecase('unknown');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<NotFoundFailure>());
  });
}

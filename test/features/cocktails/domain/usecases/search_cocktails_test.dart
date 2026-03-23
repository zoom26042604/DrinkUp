import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:drinkup/core/errors/failures.dart';
import 'package:drinkup/core/network/api_result.dart';
import 'package:drinkup/features/cocktails/domain/entities/cocktail.dart';
import 'package:drinkup/features/cocktails/domain/repositories/cocktail_repository.dart';
import 'package:drinkup/features/cocktails/domain/usecases/search_cocktails.dart';

class MockCocktailRepository extends Mock implements CocktailRepository {}

void main() {
  late MockCocktailRepository mockRepository;
  late SearchCocktails usecase;

  setUp(() {
    mockRepository = MockCocktailRepository();
    usecase = SearchCocktails(mockRepository);
  });

  const tCocktail = Cocktail(
    id: '11007',
    name: 'Margarita',
    isAlcoholic: true,
    thumbnailUrl: 'https://example.com/thumb.jpg',
    ingredients: [],
  );

  test('returns ApiSuccess when repository returns cocktails', () async {
    when(() => mockRepository.searchByName(any()))
        .thenAnswer((_) async => const ApiSuccess([tCocktail]));

    final result = await usecase('margarita');

    expect(result, isA<ApiSuccess>());
    verify(() => mockRepository.searchByName('margarita')).called(1);
  });

  test('returns ValidationFailure when query is empty', () async {
    final result = await usecase('');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<ValidationFailure>());
    verifyNever(() => mockRepository.searchByName(any()));
  });

  test('returns ValidationFailure when query is only whitespace', () async {
    final result = await usecase('   ');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<ValidationFailure>());
  });

  test('propagates repository failure', () async {
    when(() => mockRepository.searchByName(any()))
        .thenAnswer((_) async => const ApiError(NotFoundFailure()));

    final result = await usecase('unknown');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<NotFoundFailure>());
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:drinkup/core/errors/failures.dart';
import 'package:drinkup/core/network/api_result.dart';
import 'package:drinkup/features/cocktails/domain/entities/ingredient_detail.dart';
import 'package:drinkup/features/cocktails/domain/repositories/cocktail_repository.dart';
import 'package:drinkup/features/cocktails/domain/usecases/get_ingredient_by_id.dart';

class MockCocktailRepository extends Mock implements CocktailRepository {}

const tIngredient = IngredientDetail(
  id: '552',
  name: 'Gin',
  type: 'Gin',
  isAlcoholic: true,
  abv: '40',
  imageSmallUrl: 'https://example.com/gin-small.png',
  imageMediumUrl: 'https://example.com/gin-medium.png',
  imageLargeUrl: 'https://example.com/gin.png',
);

void main() {
  late MockCocktailRepository mockRepository;
  late GetIngredientById usecase;

  setUp(() {
    mockRepository = MockCocktailRepository();
    usecase = GetIngredientById(mockRepository);
  });

  test('returns ApiSuccess with ingredient on valid id', () async {
    when(() => mockRepository.getIngredientById(any()))
        .thenAnswer((_) async => const ApiSuccess(tIngredient));

    final result = await usecase('552');

    expect(result, isA<ApiSuccess<IngredientDetail>>());
    expect((result as ApiSuccess).data.name, 'Gin');
    verify(() => mockRepository.getIngredientById('552')).called(1);
  });

  test('returns NotFoundFailure when id does not exist', () async {
    when(() => mockRepository.getIngredientById(any()))
        .thenAnswer((_) async => const ApiError(NotFoundFailure()));

    final result = await usecase('999');

    expect(result, isA<ApiError>());
    expect((result as ApiError).failure, isA<NotFoundFailure>());
  });
}

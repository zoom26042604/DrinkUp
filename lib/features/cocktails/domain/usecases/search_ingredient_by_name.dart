import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_result.dart';
import '../entities/ingredient_detail.dart';
import '../repositories/cocktail_repository.dart';

class SearchIngredientByName {
  final CocktailRepository _repository;
  const SearchIngredientByName(this._repository);

  Future<ApiResult<List<IngredientDetail>>> call(String name) {
    if (name.trim().isEmpty) {
      return Future.value(
        const ApiError(ValidationFailure('Search query cannot be empty.')),
      );
    }
    return _repository.searchIngredientByName(name.trim());
  }
}

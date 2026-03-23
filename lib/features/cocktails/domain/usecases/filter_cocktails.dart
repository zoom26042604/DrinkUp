import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';
import '../repositories/cocktail_repository.dart';

enum FilterType { category, ingredient, alcoholic, glass }

class FilterCocktailsParams {
  final FilterType type;
  final String value;
  const FilterCocktailsParams({required this.type, required this.value});
}

class FilterCocktails {
  final CocktailRepository _repository;
  const FilterCocktails(this._repository);

  Future<ApiResult<List<Cocktail>>> call(FilterCocktailsParams params) {
    if (params.value.trim().isEmpty) {
      return Future.value(
        const ApiError(ValidationFailure('Filter value cannot be empty.')),
      );
    }
    return switch (params.type) {
      FilterType.category => _repository.filterByCategory(params.value),
      FilterType.ingredient => _repository.filterByIngredient(params.value),
      FilterType.alcoholic =>
        _repository.filterByAlcoholic(params.value == 'Alcoholic'),
      FilterType.glass => _repository.filterByGlass(params.value),
    };
  }
}

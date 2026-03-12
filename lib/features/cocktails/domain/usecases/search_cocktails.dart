import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';
import '../repositories/cocktail_repository.dart';

class SearchCocktails {
  final CocktailRepository _repository;
  const SearchCocktails(this._repository);

  Future<ApiResult<List<Cocktail>>> call(String name) {
    if (name.trim().isEmpty) {
      return Future.value(
        const ApiError(ValidationFailure('Search query cannot be empty.')),
      );
    }
    return _repository.searchByName(name.trim());
  }
}

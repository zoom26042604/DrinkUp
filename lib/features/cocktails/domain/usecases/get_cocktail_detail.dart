import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';
import '../repositories/cocktail_repository.dart';

class GetCocktailDetail {
  final CocktailRepository _repository;
  const GetCocktailDetail(this._repository);

  Future<ApiResult<Cocktail>> call(String id) {
    if (id.trim().isEmpty) {
      return Future.value(
        const ApiError(ValidationFailure('Cocktail id cannot be empty.')),
      );
    }
    return _repository.getById(id);
  }
}

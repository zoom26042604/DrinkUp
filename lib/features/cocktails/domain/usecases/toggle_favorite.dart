import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';
import '../repositories/cocktail_repository.dart';

class ToggleFavorite {
  final CocktailRepository _repository;
  const ToggleFavorite(this._repository);

  Future<ApiResult<bool>> call(Cocktail cocktail) =>
      _repository.toggleFavorite(cocktail);
}

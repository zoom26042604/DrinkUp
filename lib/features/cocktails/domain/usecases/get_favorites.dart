import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';
import '../repositories/cocktail_repository.dart';

class GetFavorites {
  final CocktailRepository _repository;
  const GetFavorites(this._repository);

  Future<ApiResult<List<Cocktail>>> call() => _repository.getFavorites();
}

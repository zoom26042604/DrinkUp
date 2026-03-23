import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';
import '../repositories/cocktail_repository.dart';

class GetRandomCocktail {
  final CocktailRepository _repository;
  const GetRandomCocktail(this._repository);

  Future<ApiResult<Cocktail>> call() => _repository.getRandom();
}

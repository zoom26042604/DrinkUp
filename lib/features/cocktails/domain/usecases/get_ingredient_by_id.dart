import '../../../../core/network/api_result.dart';
import '../entities/ingredient_detail.dart';
import '../repositories/cocktail_repository.dart';

class GetIngredientById {
  final CocktailRepository _repository;
  const GetIngredientById(this._repository);

  Future<ApiResult<IngredientDetail>> call(String id) =>
      _repository.getIngredientById(id);
}

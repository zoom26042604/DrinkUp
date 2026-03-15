import '../../../../core/network/api_result.dart';
import '../repositories/cocktail_repository.dart';

class GetCategories {
  final CocktailRepository _repository;
  const GetCategories(this._repository);

  Future<ApiResult<List<String>>> call() => _repository.getCategories();
}

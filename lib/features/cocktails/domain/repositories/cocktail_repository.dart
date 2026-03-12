import '../../../../core/network/api_result.dart';
import '../entities/cocktail.dart';

abstract interface class CocktailRepository {
  Future<ApiResult<List<Cocktail>>> searchByName(String name);
  Future<ApiResult<List<Cocktail>>> searchByFirstLetter(String letter);
  Future<ApiResult<Cocktail>> getById(String id);
  Future<ApiResult<Cocktail>> getRandom();
  Future<ApiResult<List<Cocktail>>> filterByCategory(String category);
  Future<ApiResult<List<Cocktail>>> filterByIngredient(String ingredient);
  Future<ApiResult<List<Cocktail>>> filterByAlcoholic(bool alcoholic);
  Future<ApiResult<List<Cocktail>>> filterByGlass(String glass);
  Future<ApiResult<List<String>>> getCategories();
  Future<ApiResult<List<String>>> getGlasses();
  Future<ApiResult<List<String>>> getIngredientNames();
  Future<ApiResult<List<Cocktail>>> getFavorites();
  Future<ApiResult<bool>> toggleFavorite(Cocktail cocktail);
}

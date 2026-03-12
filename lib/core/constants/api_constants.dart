abstract class ApiConstants {
  static const String baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1';

  static const String searchEndpoint = '/search.php';
  static const String lookupEndpoint = '/lookup.php';
  static const String randomEndpoint = '/random.php';
  static const String filterEndpoint = '/filter.php';
  static const String listEndpoint = '/list.php';

  static const int connectTimeoutMs = 10000;
  static const int receiveTimeoutMs = 10000;

  static const String ingredientImageBaseUrl =
      'https://www.thecocktaildb.com/images/ingredients';
}

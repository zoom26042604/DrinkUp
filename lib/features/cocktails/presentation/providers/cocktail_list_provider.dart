// Provider Riverpod pour la liste de cocktails
// - StateNotifierProvider ou AsyncNotifierProvider
// - État : CocktailListState { isLoading, cocktails, error, currentFilter }
// - Actions exposées :
//   - searchByName(String query)
//   - filterByCategory(String category)
//   - filterByIngredient(String ingredient)
//   - loadRandom()
// - Injecte SearchCocktailsUseCase, FilterCocktailsUseCase, GetRandomCocktailUseCase

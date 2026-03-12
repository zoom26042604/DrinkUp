// Source de données distante pour les cocktails (appels API réels)
// Interface + implémentation avec Dio/Retrofit
// Endpoints couverts :
// - searchCocktailsByName(String name)      → /search.php?s=
// - searchCocktailsByFirstLetter(String l)  → /search.php?f=
// - getCocktailById(String id)              → /lookup.php?i=
// - getRandomCocktail()                     → /random.php
// - filterByCategory(String category)       → /filter.php?c=
// - filterByIngredient(String ingredient)   → /filter.php?i=
// - filterByAlcoholic(String filter)        → /filter.php?a=
// - getCategories()                         → /list.php?c=list
// - getIngredients()                        → /list.php?i=list
// - getGlasses()                            → /list.php?g=list
// Retourne des CocktailModel / List<CocktailModel>
// Lance des exceptions (ServerException, NotFoundException) en cas d'erreur

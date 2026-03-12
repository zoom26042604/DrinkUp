// Source de données locale pour les cocktails (cache SharedPreferences)
// - saveFavoriteCocktail(CocktailModel)     → sauvegarde en JSON local
// - removeFavoriteCocktail(String id)       → supprime un favori
// - getFavoriteCocktails()                  → retourne la liste des favoris
// - isFavorite(String id)                   → vérifie si un cocktail est favori
// - cacheSearchResults(String query, List<CocktailModel>) → cache une recherche
// - getCachedSearchResults(String query)    → récupère depuis le cache
// Lance CacheException en cas d'erreur de lecture/écriture

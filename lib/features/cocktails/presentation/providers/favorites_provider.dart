// Provider Riverpod pour la gestion des favoris
// - StateNotifierProvider<FavoritesNotifier, List<Cocktail>>
// - Chargement initial des favoris depuis le stockage local au démarrage
// - Actions : toggleFavorite(Cocktail), isFavorite(String id)
// - Persiste les changements via ToggleFavoriteUseCase

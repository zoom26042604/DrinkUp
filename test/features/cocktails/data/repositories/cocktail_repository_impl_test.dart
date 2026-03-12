// Tests unitaires de CocktailRepositoryImpl
// - Mocks : CocktailRemoteDatasource, CocktailLocalDatasource
// - Test searchByName succès : retourne ApiResult.success avec List<Cocktail>
// - Test searchByName échec réseau : retourne ApiResult.error(ServerFailure)
// - Test searchByName introuvable : retourne ApiResult.error(NotFoundFailure)
// - Test toggleFavorite ajout : appelle localDatasource.saveFavorite
// - Test toggleFavorite suppression : appelle localDatasource.removeFavorite
// - Vérifie la conversion Model → Entity

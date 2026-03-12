// Implémentation concrète de CocktailRepository (couche data)
// - Injecte CocktailRemoteDatasource et CocktailLocalDatasource
// - Orchestre : appel distant → convertir Model en Entity → retourner ApiResult
// - Gestion des erreurs : catch exceptions → retourner Failure approprié
// - Stratégie cache : tente le cache local avant l'appel réseau si applicable
// - Convertit les ServerException/NotFoundException en ServerFailure/NotFoundFailure

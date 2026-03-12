// Tests unitaires du UseCase ToggleFavorite
// - Mock de CocktailRepository
// - Test ajout favori : si non favori → retourne true (ajouté)
// - Test suppression favori : si déjà favori → retourne false (supprimé)
// - Test erreur cache : si localDatasource échoue → retourne ApiResult.error(CacheFailure)

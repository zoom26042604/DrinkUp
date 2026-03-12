// Tests unitaires du UseCase SearchCocktails
// - Mock de CocktailRepository
// - Test appel nominal : retourne ApiResult<List<Cocktail>> avec query valide
// - Test query vide : retourne ApiResult.error(ValidationFailure) sans appeler le repo
// - Test propagation erreur : si repo retourne error, usecase le propage tel quel

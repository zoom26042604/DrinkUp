// Tests unitaires de CocktailRemoteDatasource
// - Mock de l'instance Dio
// - Test searchByName : retourne une liste de CocktailModel si 200 OK
// - Test searchByName : lance NotFoundException si API retourne drinks: null
// - Test getCocktailById : retourne un CocktailModel si 200 OK
// - Test getCocktailById : lance NotFoundException si id invalide
// - Test getRandomCocktail : retourne un CocktailModel
// - Test réseau KO : lance ServerException si timeout / erreur Dio
// - Utilise des fixtures JSON (fichiers dans test/fixtures/)

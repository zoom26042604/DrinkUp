// Wrapper générique pour les résultats d'appels API
// Pattern Either<Failure, T> sans dépendance externe
// - Classe sealed ApiResult<T> avec deux sous-types :
//   - Success<T> : contient la donnée
//   - Error<T>   : contient un Failure
// Permet de forcer la gestion des erreurs à chaque appel sans try/catch partout

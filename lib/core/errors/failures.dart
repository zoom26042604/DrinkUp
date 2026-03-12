// Classe abstraite Failure et ses sous-classes (côté domain)
// - Failure (abstract) : base commune
// - ServerFailure : échec de communication avec l'API
// - NotFoundFailure : aucun résultat retourné par l'API
// - CacheFailure : échec du cache local
// - NetworkFailure : absence de connexion réseau
// Utilisé dans les UseCases via Either<Failure, T>

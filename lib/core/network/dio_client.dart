// Configuration et initialisation de l'instance Dio
// - Base URL injectée depuis api_constants.dart
// - Intercepteur de logs (requêtes/réponses en mode debug)
// - Intercepteur de gestion d'erreurs global (transforme les DioException en Failure)
// - Headers par défaut (Content-Type: application/json)
// - ConnectTimeout et receiveTimeout

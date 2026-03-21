class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'An error occurred on the server.']);
}

class NotFoundException implements Exception {
  const NotFoundException();
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error.']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication error.']);
}

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

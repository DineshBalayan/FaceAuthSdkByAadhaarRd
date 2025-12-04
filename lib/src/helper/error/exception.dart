class ServerException implements Exception {
  final String message;
  final String errorCode;

  ServerException(this.errorCode, this.message);
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

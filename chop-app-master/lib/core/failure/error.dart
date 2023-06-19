class NetworkException implements Exception {}

class CacheException implements Exception {}

class UnauthenticatedException implements Exception {}

class OtherException implements Exception {
  final String errorMessage;

  OtherException(this.errorMessage);
}

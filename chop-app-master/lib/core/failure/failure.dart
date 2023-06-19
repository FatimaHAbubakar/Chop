abstract class Failure {
  late String errorMessage;
}

class NetworkFailure extends Failure {
  @override
  String get errorMessage =>
      'Could not connect to server. Please check your internet connection.';
}

class CacheFailure extends Failure {
  @override
  String get errorMessage => 'Cache failure';
}

class UnauthenticatedFailure extends Failure {
  @override
  String get errorMessage => 'Unauthenticated.';
}

class OtherFailure extends Failure {
  final String otherErrorMessage;

  @override
  String get errorMessage => otherErrorMessage;

  OtherFailure(this.otherErrorMessage);
}

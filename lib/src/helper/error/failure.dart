abstract class Failure {
  final String errorCode;
  final String message;

  Failure(this.errorCode, this.message);
}

class ServerFailure extends Failure {
  ServerFailure({required String errorCode, required String message})
    : super(errorCode, message);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message, '');
}

class CacheFailure extends Failure {
  CacheFailure({required String message}) : super(message, '');
}

import 'exception.dart';
import 'failure.dart';

Failure mapExceptionToFailure(Exception e) {
  if (e is ServerException) {
    return ServerFailure(errorCode: e.errorCode, message: e.message);
  } else if (e is CacheException) {
    return CacheFailure(message: e.message);
  } else {
    return NetworkFailure(message: 'Network Issue');
  }
}

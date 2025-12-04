import 'package:dartz/dartz.dart';
import 'error/failure.dart';

abstract class CoreUseCase<Type, Params> {
  Future<Either<Failure, Type>> call({required Params param});
}

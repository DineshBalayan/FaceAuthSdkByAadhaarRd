import 'package:dartz/dartz.dart';
import '../../data/models/afa_verification_request.dart';
import '../../data/models/response/afa_verify_response.dart';
import '../../helper/core_use_case.dart';
import '../../helper/error/failure.dart';
import '../repository/server_repository.dart';

class FaceAuthRequestUseCase extends CoreUseCase<AfaVerifyResponse, AfaVerificationRequest> {
  final ServerRepository repository;

  FaceAuthRequestUseCase(this.repository);

  @override
  Future<Either<Failure, AfaVerifyResponse>> call({required AfaVerificationRequest param}) {
    return repository.faceAuthRequest(param);
  }
}

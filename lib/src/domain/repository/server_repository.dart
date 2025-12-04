import '../../data/models/afa_verification_request.dart';
import '../../data/models/dashboard_request.dart';
import 'package:dartz/dartz.dart';
import '../../data/models/response/afa_verify_response.dart';
import '../../helper/error/failure.dart';
import '../entities/dashboard_entity.dart';

abstract class ServerRepository {
  Future<Either<Failure, DashboardEntity>> dashboardLoad(DashboardRequest request);
  Future<Either<Failure, AfaVerifyResponse>> faceAuthRequest(AfaVerificationRequest request);
}
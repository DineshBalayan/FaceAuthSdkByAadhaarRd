import 'package:dartz/dartz.dart';

import '../../data/models/afa_verification_request.dart';
import '../../data/models/auth_session.dart';
import '../../data/models/dashboard_request.dart';
import '../../data/models/response/afa_verify_response.dart';
import '../../helper/error/failure.dart';
import '../entities/dashboard_entity.dart';

abstract class ServerRepository {
  Future<Either<Failure, DashboardEntity>> dashboardLoad(DashboardRequest request);

  Future<Either<Failure, AfaVerifyResponse>> faceAuthRequest(AfaVerificationRequest request);

  // --- Face Auth / Attestation / RD ---
  Future<AuthSession> performAttestation(String appId, Map<String, dynamic>? userData);

  Future<bool> isRdAppInstalled(String packageName);

  Future<String?> startFaceRD(String pidOptions);

  Future<Map<String, dynamic>> verifyIntegrityOnServer(
      String integrityToken,
      String backendBaseUrl,
      );
}

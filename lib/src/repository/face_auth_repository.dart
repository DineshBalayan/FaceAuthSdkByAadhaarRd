import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../face_auth_sdk_platform_interface.dart';
import '../helper/error/exception.dart';
import '../data/models/auth_session.dart';

class FaceAuthRepository {
  final FaceAuthSdkPlatform _platform = FaceAuthSdkPlatform.instance;

  Future<AuthSession> performAttestation(
    String appId,
    Map<String, dynamic>? userData,
  ) async {
    final res = await _platform.startAuthentication();
    if (res == null || res['status'] != 'success') {
      throw Exception(res?['message'] ?? 'attestation_failed');
    }
    return AuthSession.fromMap(res);
  }


  Future<bool> isRdAppInstalled(String packageName) async {
    final r = await _platform.isRdAppInstalled(packageName);
    return r ?? false;
  }

  Future<Map<String, dynamic>> verifyIntegrityOnServer(
    String integrityToken,
    String backendBaseUrl,
  ) async {
    // Implement your HTTP client. For clarity, we return a placeholder map.
    // Integrator should use provided backend endpoints.
    throw UnimplementedError(
      'Use your HTTP client to call backend /v1/auth/integrity/verify',
    );
  }

  Future<String?> startFaceRD(String pidOptions) async {
    try {
      return await _platform.startAadhaarRD(pidOptions);
    } on PlatformException catch (e) {
      debugPrint("PlatformException in SecurityService: ${e.message}");
      throw ServerException(e.code, e.message ?? "Native RD error (unknown)");
    } catch (e) {
      ServerException serv_ex = ServerException(
        e is ServerException ? e.errorCode : 'UNKNOWN',
        e is ServerException ? e.message : e.toString(),
      );
      debugPrint("Unexpected error in SecurityService: ${serv_ex.message}");
      throw ServerException(
        e is ServerException ? e.errorCode : 'UNKNOWN',
        e is ServerException ? e.message : e.toString(),
      );
    }
  }
}

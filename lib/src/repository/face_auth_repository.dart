import '../face_auth_sdk_platform_interface.dart';
import '../models/auth_session.dart';
import '../models/auth_result.dart';

class FaceAuthRepository {
  final FaceAuthSdkPlatform _platform = FaceAuthSdkPlatform.instance;

  Future<AuthSession> performAttestation(String appId, Map<String, dynamic>? userData) async {
    final res = await _platform.startAuthentication();
    if (res == null || res['status'] != 'success') {
      throw Exception(res?['message'] ?? 'attestation_failed');
    }
    return AuthSession.fromMap(res);
  }

  Future<bool> isRdAppInstalled() async {
    final r = await _platform.isRdAppInstalled();
    return r ?? false;
  }

  Future<AuthResult> startAadhaarRD() async {
    final r = await _platform.startAadhaarRD();
    if (r == null) {
      throw Exception('RD returned null');
    }
    return AuthResult.fromMap(r);
  }

  Future<Map<String, dynamic>> verifyIntegrityOnServer(String integrityToken, String backendBaseUrl) async {
    // Implement your HTTP client. For clarity, we return a placeholder map.
    // Integrator should use provided backend endpoints.
    throw UnimplementedError('Use your HTTP client to call backend /v1/auth/integrity/verify');
  }
}

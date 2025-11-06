import 'package:uuid/uuid.dart';

import '../../face_auth_sdk.dart';
import '../models/auth_result.dart';

class FaceAuthRepository {
  final FaceAuthSdk _sdk = FaceAuthSdk();

  Future<AuthResult> startAuth() async {
    // Step 1: Platform attestation + backend verification
    final result = await _sdk.startFaceAuthentication(); // already returns session token in result
    if (result == null) throw Exception('Null response from platform');
    return AuthResult.fromMap(result);
  }

  Future<AuthResult> startFaceAuthPlatform() async {
    final result = await _sdk.startFaceAuthentication(); // Face RD call
    if (result == null) throw Exception('Face Auth failed');
    return AuthResult.fromMap(result);
  }

  Future<AuthResult> startOtpBackend() async {
    // Implement backend OTP call here with session token
    final result = {
      "status": "success",
      "message": "OTP verified",
      "transactionId": Uuid().toString()
    };
    return AuthResult.fromMap(result);

  }
}

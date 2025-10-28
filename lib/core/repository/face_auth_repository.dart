import 'package:face_auth_sdk/face_auth_sdk.dart';
import '../models/auth_result.dart';

class FaceAuthRepository {
  final FaceAuthSdk _sdk = FaceAuthSdk();

  Future<AuthResult> startAuth() async {
    final result = await _sdk.startFaceAuthentication();
    if (result == null) throw Exception('Null response from platform');

    return AuthResult.fromMap(result);
  }
}

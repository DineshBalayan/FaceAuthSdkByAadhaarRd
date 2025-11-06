import 'face_auth_sdk_platform_interface.dart';

class FaceAuthSdk {
  Future<String?> getPlatformVersion() {
    return FaceAuthSdkPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>?> startFaceAuthentication() {
    return FaceAuthSdkPlatform.instance.startFaceAuthentication();
  }
}

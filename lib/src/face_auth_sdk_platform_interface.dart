import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'method_channel_face_auth_sdk.dart';

abstract class FaceAuthSdkPlatform extends PlatformInterface {
  FaceAuthSdkPlatform() : super(token: _token);

  static final Object _token = Object();
  static FaceAuthSdkPlatform _instance = MethodChannelFaceAuthSdk();
  static FaceAuthSdkPlatform get instance => _instance;
  static set instance(FaceAuthSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();
  Future<Map<String, dynamic>?> startAuthentication();
  Future<Map<String, dynamic>?> startAadhaarRD();
  Future<String?> requestPlayIntegrity();

  Future<bool?> isRdAppInstalled();
  Future<bool?> isJailBroken();
  Future<void> exitApp();
}

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'method_channel_auth_sdk.dart';

abstract class AadhaarAuthSdkPlatform extends PlatformInterface {
  AadhaarAuthSdkPlatform() : super(token: _token);

  static final Object _token = Object();
  static AadhaarAuthSdkPlatform _instance = MethodChannelAuthSdk();

  static AadhaarAuthSdkPlatform get instance => _instance;

  static set instance(AadhaarAuthSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Future<Map<String, dynamic>?> startAuthentication();

  Future<String?> startAadhaarRD(String pidOptions);

  Future<String?> requestPlayIntegrity();

  Future<bool?> isRdAppInstalled(String packageName);

  Future<bool?> isJailBroken();

  Future<void> exitApp();
}

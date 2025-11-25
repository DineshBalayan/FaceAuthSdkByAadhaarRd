import 'package:face_auth_sdk/face_auth_sdk.dart';
import 'package:flutter/material.dart';

export 'src/models/auth_session.dart';
export 'src/models/auth_result.dart';
export 'src/models/integrity_cache.dart';
export 'src/repository/face_auth_repository.dart';
export 'src/cubit/face_auth_cubit.dart';
export 'src/ui/auth_options_screen.dart';
export 'src/face_auth_sdk_platform_interface.dart';

class FaceAuthSdk {
  // Public API

  Future<String?> getPlatformVersion() {
    return FaceAuthSdkPlatform.instance.getPlatformVersion();
  }

  Future<String?> requestPlayIntegrity() {
    return FaceAuthSdkPlatform.instance.requestPlayIntegrity();
  }

  Future<Map<String, dynamic>?> startAuthenticationNative() {
    return FaceAuthSdkPlatform.instance.startAuthentication();
  }

  Future<Map<String, dynamic>?> startAadhaarRD() {
    return FaceAuthSdkPlatform.instance.startAadhaarRD();
  }

  Future<bool?> isRdAppInstalled() {
    return FaceAuthSdkPlatform.instance.isRdAppInstalled();
  }

  Future<bool?> isJailBroken() {
    return FaceAuthSdkPlatform.instance.isJailBroken();
  }

  Future<void> exitApp() {
    return FaceAuthSdkPlatform.instance.exitApp();
  }

  /// Launches SDK UI (integrator passes BuildContext).
  Future<AuthResult?> launchAuthenticationUI(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthOptionsScreen()),
    );
    if (result is AuthResult) return result;
    return null;
  }
}

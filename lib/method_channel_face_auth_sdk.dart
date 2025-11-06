import 'package:flutter/services.dart';
import 'face_auth_sdk_platform_interface.dart';

class MethodChannelFaceAuthSdk extends FaceAuthSdkPlatform {
  final methodChannel = const MethodChannel('face_auth_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, dynamic>?> startFaceAuthentication() async {
    final result = await methodChannel.invokeMethod<Map>('startFaceAuthentication');
    if (result == null) return null;
    return Map<String, dynamic>.from(result);
  }
}

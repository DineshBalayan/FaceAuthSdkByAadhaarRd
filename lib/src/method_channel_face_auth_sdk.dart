import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'face_auth_sdk_platform_interface.dart';

class MethodChannelFaceAuthSdk extends FaceAuthSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('face_auth_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final ver = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return ver;
  }

  @override
  Future<Map<String, dynamic>?> startAuthentication() async {
    final res = await methodChannel.invokeMapMethod<String, dynamic>('startAuth');
    return res;
  }

  @override
  Future<Map<String, dynamic>?> startAadhaarRD() async {
    final res = await methodChannel.invokeMapMethod<String, dynamic>('startFaceRD');
    return res;
  }

  @override
  Future<String?> requestPlayIntegrity() async {
    final res = await methodChannel.invokeMethod<String>('requestPlayIntegrity');
    return res;
  }

  @override
  Future<bool?> isRdAppInstalled() async {
    final res = await methodChannel.invokeMethod<bool>('isRdAppInstalled');
    return res;
  }

  @override
  Future<bool?> isJailBroken() async {
    final res = await methodChannel.invokeMethod<bool>('isJailBroken');
    return res;
  }

  @override
  Future<void> exitApp() async {
    await methodChannel.invokeMethod('exitApp');
  }
}

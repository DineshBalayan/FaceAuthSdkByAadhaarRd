import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'auth_sdk_platform_interface.dart';
import 'helper/error/exception.dart';

class MethodChannelAuthSdk extends AadhaarAuthSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('aadhaar_auth_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final ver = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return ver;
  }

  @override
  Future<Map<String, dynamic>?> startAuthentication() async {
    final res = await methodChannel.invokeMapMethod<String, dynamic>(
      'startAuth',
    );
    return res;
  }

  @override
  Future<String?> startAadhaarRD(String pidOptions) async {
    try {
      final result = await methodChannel.invokeMethod<String>('startFaceRD', {
        'pidOptions': pidOptions,
      });
      if (result == null || result.isEmpty) {
        throw ServerException("RD Exception", "PID XML is empty");
      }
      return result;
    } on PlatformException catch (e) {
      throw ServerException(
        e.code,
        e.message ?? "Unknown Face RD error from native",
      );
    } catch (e) {
      throw ServerException(
        "Exception",
        "Unexpected Face RD error: ${e.toString()}",
      );
    }
  }

  @override
  Future<String?> requestPlayIntegrity() async {
    final res = await methodChannel.invokeMethod<String>(
      'requestPlayIntegrity',
    );
    return res;
  }

  @override
  Future<bool?> isRdAppInstalled(String packageName) async {
    try {
      if (Platform.isAndroid) {
        return await methodChannel.invokeMethod('isRdAppInstalled', {
              'packageName': packageName,
            }) ??
            false;
      } else if (Platform.isIOS) {
        return await methodChannel.invokeMethod('isRdAppInstalled') ?? false;
      }
    } catch (e) {
      debugPrint('Error checking app installed: $e');
    }
    return false;
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

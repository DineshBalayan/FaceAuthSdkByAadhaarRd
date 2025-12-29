import 'package:aadhaar_auth_sdk/aadhaar_auth_sdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class FaceAuthStartChannel {
  static const _channel = MethodChannel('aadhaar_auth_sdk/start');

  static void register(BuildContext context) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'start') {
        final appCode = call.arguments['appCode'];
        final userData = call.arguments['userData'];

        await AadhaarAuthSdk.instance.integrate(
          context,
          appCode: appCode,
          userData: userData,
        );
      }
    });
  }
}

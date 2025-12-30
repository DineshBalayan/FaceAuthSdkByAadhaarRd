import 'package:aadhaar_auth_sdk/aadhaar_auth_sdk.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../aadhaar_sdk_entry.dart';
import '../main.dart';

class AadhaarStartChannel {
  static const _channel = MethodChannel('aadhaar_auth_sdk/start');

  static void register() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'start') {
        final appCode = call.arguments['appCode'];
        final userData = call.arguments['userData'];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final nav = sdkNavigatorKey.currentState;
          if (nav == null) {
            debugPrint("❌ Navigator not ready");
            return;
          }

          nav.push(
            MaterialPageRoute(
              builder: (_) => AadhaarSdkEntry(
                appCode: appCode,
                userData: userData,
              ),
            ),
          );
        });
      }
    });
  }
}

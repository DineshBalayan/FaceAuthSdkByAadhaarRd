import 'package:aadhaar_auth_sdk/src/aadhaar_auth_start_channel.dart';
import 'package:flutter/material.dart';

class AadhaarSdkEntry extends StatelessWidget {
  final String appCode;
  final String userData;

  const AadhaarSdkEntry({
    super.key,
    required this.appCode,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {

    debugPrint("AADHAAR_AUTH_SDK:- AadhaarSdkEntry build() called");
    return Scaffold(
      body: Center(
        child: Text('Starting Aadhaar for $appCode'),
      ),
    );
  }
}

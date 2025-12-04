import 'package:face_auth_sdk/src/models/auth_result.dart';
import 'package:face_auth_sdk/src/ui/auth_options_screen.dart';
import 'package:flutter/material.dart';

class FaceAuthSdk {
  FaceAuthSdk._();
  static final FaceAuthSdk instance = FaceAuthSdk._();

  Future<AuthResult?> launchUI(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AuthOptionsScreen()),
    );

    if (result is AuthResult) return result;
    return null;
  }
}

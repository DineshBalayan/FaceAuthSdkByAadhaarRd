import 'package:face_auth_sdk/src/bloc/face_auth_cubit.dart';
import 'package:face_auth_sdk/src/di/injection_container.dart';
import 'package:face_auth_sdk/src/helper/faceauthhelper.dart';
import 'package:face_auth_sdk/src/ui/auth_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaceAuthSdk {
  FaceAuthSdk._();
  static final FaceAuthSdk instance = FaceAuthSdk._();

  Future<FaceAuthResult?> launchUI(BuildContext context, {required String appCode, required String userData}) async {
    // ✅ ENSURE SDK IS INITIALIZED
    await injectionContainer();

    if (!context.mounted) {
      return null;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<FaceAuthCubit>(
            param1: appCode,
            param2: userData,
          )..startAuthentication(appId: appCode),
          child: const AuthOptionsScreen(),
        ),
      ),
    );

    if (result is FaceAuthResult) return result;
    return null;
  }
}

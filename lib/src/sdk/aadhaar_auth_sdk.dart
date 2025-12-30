import 'package:aadhaar_auth_sdk/aadhaar_auth_sdk.dart';
import 'package:aadhaar_auth_sdk/src/di/injection_container.dart';
import 'package:aadhaar_auth_sdk/src/ui/auth_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/aadhaar_auth_cubit.dart';

class AadhaarAuthSdk {
  AadhaarAuthSdk._();
  static final AadhaarAuthSdk instance = AadhaarAuthSdk._();

  Future<AuthResult?> integrate(BuildContext context, {required String appCode, required String userData}) async {
    debugPrint("AADHAAR_AUTH_SDK:- AadhaarAuthSdk.dart - integrate() called");
     await injectionContainer();

    if (!context.mounted) {
      return null;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<AadhaarAuthCubit>(
            param1: appCode,
            param2: userData,
          )..startAuthentication(appId: appCode),
          child: const AuthOptionsScreen(),
        ),
      ),
    );

    if (result is AuthResult) return result;
    return null;
  }
}

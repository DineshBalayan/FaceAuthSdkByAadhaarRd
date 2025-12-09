import 'package:face_auth_sdk/src/helper/faceauthhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/face_auth_cubit.dart';
import '../data/models/auth_result.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: BlocConsumer<FaceAuthCubit, FaceAuthState>(
        listener: (context, state) {
          if (state is FaceAuthSuccess) {
            Navigator.pop(context, state.result);
          }
          if (state is FaceAuthFailure) {
            FaceAuthResult fr = FaceAuthResult.failure(
              state.errorCode,
              state.error,
            );
            Navigator.pop(context, fr);
          }
        },
        builder: (context, state) {
          if (state is FaceAuthProgress) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(state.message),
              ],
            );
          }

          if (state is FaceAuthOptions) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state.dashboard.isApproved)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        AuthResult(
                          status: 'otp',
                          transactionId: state.session.transactionId,
                        ),
                      );
                    },
                    child: const Text('Continue with OTP'),
                  ),

                if (state.dashboard.isApproved)
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FaceAuthCubit>().continueWithRD(),
                    child: const Text('Continue with Face Auth'),
                  ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

enum FaceAuthStep {
  initializing,
  attestationCheck,
  dashboardCall,
  rdCheck,
  rdCapture,
  backendVerify,
  success,
  failure,
}
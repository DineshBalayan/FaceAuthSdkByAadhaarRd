import 'package:face_auth_sdk/src/helper/faceauthhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/face_auth_cubit.dart';
import '../data/models/auth_result.dart';
import '../di/injection_container.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<FaceAuthCubit>()
            ..startAuthentication(appId: 'INTEGRATOR_APP_ID'),
      child: Scaffold(
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
            if (state is FaceAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FaceAuthOptions) {
              return Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Session: ${state.session.transactionId}\nresponseData: ${state.session.responseData.toString()}',
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // OTP selected — integrator handles OTP path
                          Navigator.pop(
                            context,
                            AuthResult(
                              status: 'success',
                              transactionId: state.session.transactionId,
                              otpFlowSelected: true,
                            ),
                          );
                        },
                        child: const Text('Continue with OTP'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<FaceAuthCubit>().continueWithRD(),
                        child: const Text('Continue with Face Auth'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is FaceAuthRdInitializing) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text('Initializing...'));
          },
        ),
      ),
    );
  }
}

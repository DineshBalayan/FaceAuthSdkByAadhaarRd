import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/face_auth_repository.dart';
import '../cubit/face_auth_cubit.dart';
import '../models/auth_result.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = FaceAuthRepository();
    return BlocProvider(
      create: (_) => FaceAuthCubit(repo)..startAuthentication(appId: 'INTEGRATOR_APP_ID'), // integrator supplies
      child: Scaffold(
        appBar: AppBar(title: const Text('Authentication')),
        body: BlocConsumer<FaceAuthCubit, FaceAuthState>(
          listener: (context, state) {
            if (state is FaceAuthSuccess) {
              Navigator.pop(context, state.result);
            }
            if (state is FaceAuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
            }
          },
          builder: (context, state) {
            if (state is FaceAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FaceAuthOptions) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Session: ${state.session.transactionId}'),
                    ElevatedButton(
                      onPressed: () {
                        // OTP selected — integrator handles OTP path
                        Navigator.pop(context, AuthResult(status: 'success', transactionId: state.session.transactionId, otpFlowSelected: true));
                      },
                      child: const Text('Continue with OTP')
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<FaceAuthCubit>().continueWithRD(),
                      child: const Text('Continue with Face Auth')
                    ),
                  ],
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

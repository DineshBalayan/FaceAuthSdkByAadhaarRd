import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/face_auth_cubit.dart';
import '../../cubit/face_auth_state.dart';
import '../models/auth_result.dart';

class FaceAuthScreen extends StatelessWidget {
  const FaceAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Face Authentication")),
      body: BlocBuilder<FaceAuthCubit, FaceAuthState>(
        builder: (context, state) {

          if (state is FaceAuthLoading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text("Please wait, processing...")
                ],
              ),
            );
          }

          if (state is FaceAuthOptions) {
            return _OptionsUI(
              session: state.result,
              onContinue: () => context.read<FaceAuthCubit>().continueWithRD(),
            );
          }

          if (state is FaceAuthFailure) {
            return _ErrorUI(
              message: state.error,
              onRetry: () => context.read<FaceAuthCubit>().retry(),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<FaceAuthCubit>().startAuthentication(),
              child: const Text("Start Face Authentication"),
            ),
          );
        },
      ),
    );
  }
}

class _OptionsUI extends StatelessWidget {
  final AuthResult session;
  final VoidCallback onContinue;

  const _OptionsUI({
    required this.session,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Session Ready", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text("Token: {session.sessionToken}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onContinue,
            child: const Text("Proceed to Face RD"),
          ),
        ],
      ),
    );
  }
}

class _ErrorUI extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorUI({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

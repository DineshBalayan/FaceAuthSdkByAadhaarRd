import 'package:face_auth_sdk/core/repository/face_auth_repository.dart';
import 'package:face_auth_sdk/cubit/face_auth_cubit.dart';
import 'package:face_auth_sdk/cubit/face_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class FaceAuthPage extends StatelessWidget {
  const FaceAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FaceAuthRepository();

    return BlocProvider(
      create: (_) => FaceAuthCubit(repository),
      child: Scaffold(
        appBar: AppBar(title: const Text('Face Authentication')),
        body: BlocConsumer<FaceAuthCubit, FaceAuthState>(
          listener: (context, state) {
            if (state is FaceAuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Authentication Successful')),
              );
            }

            if (state is FaceAuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ ${state.error}')),
              );
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
                    const Text("Session Established ✅"),
                    const SizedBox(height: 10),
                    Text("Token: ${state.result.transactionId}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<FaceAuthCubit>().continueWithRD(),
                      child: const Text("Proceed to Face Scan"),
                    ),
                  ],
                ),
              );
            }

            if (state is FaceAuthInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FaceAuthFailure) {
              return Center(
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<FaceAuthCubit>().startAuthentication(),
                  child: const Text('Retry'),
                ),
              );
            }

            if (state is FaceAuthSuccess) {
              return Center(
                child: Text("✅ Verified User: ${state.result.transactionId}"),
              );
            }

            return Center(
              child: ElevatedButton(
                onPressed: () =>
                    context.read<FaceAuthCubit>().startAuthentication(),
                child: const Text('Start Face Authentication'),
              ),
            );
          },
        ),
      ),
    );
  }
}

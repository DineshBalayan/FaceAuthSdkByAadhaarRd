import 'package:face_auth_sdk/core/repository/face_auth_repository.dart';
import 'package:face_auth_sdk/cubit/face_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:face_auth_sdk/face_auth_sdk.dart';

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
                SnackBar(content: Text('✅ ${state.result.status}')),
              );
            } else if (state is FaceAuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            if (state is FaceAuthLoading) {
              return const Center(child: CircularProgressIndicator());
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

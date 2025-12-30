import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/aadhaar_auth_cubit.dart';
import '../data/models/auth_result.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("AADHAAR_AUTH_SDK:- AuthOptionsScreen build() called");
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: BlocConsumer<AadhaarAuthCubit, AadhaarAuthState>(
        listener: (context, state) {
          if (state is AadhaarAuthSuccess) {
            Navigator.pop(context, state.result);
          }
          if (state is AadhaarAuthFailure) {
            AuthResult fr = AuthResult(
              status:state.errorCode,
              message:state.error,
            );
            Navigator.pop(context, fr);
          }
        },
        builder: (context, state) {
          if (state is AadhaarAuthProgress) {
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

          if (state is AadhaarAuthOptions) {
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
                        context.read<AadhaarAuthCubit>().continueWithRD(),
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
part of 'aadhaar_auth_cubit.dart';

@immutable
abstract class AadhaarAuthState {}

class AadhaarAuthInitial extends AadhaarAuthState {}

class AadhaarAuthLoading extends AadhaarAuthState {}

class AadhaarAuthProgress extends AadhaarAuthState {
  final AadhaarAuthStep step;
  final String message;
  final AuthSession? session;

  AadhaarAuthProgress({
    required this.step,
    required this.message,
    this.session,
  });
}

class AadhaarAuthOptions extends AadhaarAuthState {
  final AuthSession session;
  final DashboardEntity dashboard;

  AadhaarAuthOptions({
    required this.session,
    required this.dashboard,
  });
}

class AadhaarAuthRdInitializing extends AadhaarAuthState {}

class FaceAuthSuccess extends AadhaarAuthState {
  final FaceAuthResult result;

  FaceAuthSuccess(this.result);
}

class AadhaarAuthSuccess extends AadhaarAuthState {
  final AuthResult result;

  AadhaarAuthSuccess(this.result);
}

class AadhaarAuthFailure extends AadhaarAuthState {
  final String errorCode;
  final String error;

  AadhaarAuthFailure(this.errorCode,this.error);
}

part of 'face_auth_cubit.dart';

@immutable
abstract class FaceAuthState {}

class FaceAuthInitial extends FaceAuthState {}

class FaceAuthLoading extends FaceAuthState {}

class FaceAuthProgress extends FaceAuthState {
  final FaceAuthStep step;
  final String message;
  final AuthSession? session;

  FaceAuthProgress({
    required this.step,
    required this.message,
    this.session,
  });
}

class FaceAuthOptions extends FaceAuthState {
  final AuthSession session;
  final DashboardEntity dashboard;

  FaceAuthOptions({
    required this.session,
    required this.dashboard,
  });
}

class FaceAuthRdInitializing extends FaceAuthState {}

class FaceAuthSuccess extends FaceAuthState {
  final FaceAuthResult result;

  FaceAuthSuccess(this.result);
}

class FaceAuthFailure extends FaceAuthState {
  final String errorCode;
  final String error;

  FaceAuthFailure(this.errorCode,this.error);
}

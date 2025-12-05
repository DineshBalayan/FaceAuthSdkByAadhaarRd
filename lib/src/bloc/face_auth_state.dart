part of 'face_auth_cubit.dart';

@immutable
abstract class FaceAuthState {}

class FaceAuthInitial extends FaceAuthState {}

class FaceAuthLoading extends FaceAuthState {}

class FaceAuthOptions extends FaceAuthState {
  final AuthSession session;

  FaceAuthOptions(this.session);
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

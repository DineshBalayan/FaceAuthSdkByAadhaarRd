import '../core/models/auth_result.dart';

abstract class FaceAuthState {}

class FaceAuthInitial extends FaceAuthState {}

class FaceAuthLoading extends FaceAuthState {}

class FaceAuthOptions extends FaceAuthState {
  final AuthResult result; // has sessionToken from backend
  FaceAuthOptions(this.result);
}

class FaceAuthInProgress extends FaceAuthState {} // RD capture ongoing

class FaceAuthSuccess extends FaceAuthState {
  final AuthResult result;
  FaceAuthSuccess(this.result);
}

class FaceAuthFailure extends FaceAuthState {
  final String error;
  FaceAuthFailure(this.error);
}



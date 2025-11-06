import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/repository/face_auth_repository.dart';
import 'face_auth_state.dart';

class FaceAuthCubit extends Cubit<FaceAuthState> {
  final FaceAuthRepository repository;

  FaceAuthCubit(this.repository) : super(FaceAuthInitial());

  Future<void> startAuthentication() async {
    emit(FaceAuthLoading());
    try {
      final session = await repository.startAuth(); // backend handshake + JWT
      emit(FaceAuthOptions(session)); // Show proceed UI
    } catch (e) {
      emit(FaceAuthFailure(e.toString()));
    }
  }

  Future<void> continueWithRD() async {
    emit(FaceAuthInProgress());
    try {
      final result = await repository.startFaceAuthPlatform(); // calls RD + backend verify
      emit(FaceAuthSuccess(result));
    } catch (e) {
      emit(FaceAuthFailure(e.toString()));
    }
  }

  /// 🔄 Unified Retry Logic
  void retry() {
    final current = state;
    if (current is FaceAuthOptions) {
      // User already passed attestation — retry only RD part
      continueWithRD();
    } else {
      // Restart fresh attestation
      startAuthentication();
    }
  }
}


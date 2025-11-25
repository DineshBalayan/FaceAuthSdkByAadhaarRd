import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../repository/face_auth_repository.dart';
import '../models/auth_result.dart';
import '../models/auth_session.dart';

part 'face_auth_state.dart';

class FaceAuthCubit extends Cubit<FaceAuthState> {
  final FaceAuthRepository repository;
  FaceAuthCubit(this.repository) : super(FaceAuthInitial());

  Future<void> startAuthentication({required String appId, Map<String, dynamic>? userData}) async {
    emit(FaceAuthLoading());
    try {
      // 1) Attestation (this handles PI caching)
      final session = await repository.performAttestation(appId, userData);
      emit(FaceAuthOptions(session));
    } catch (e) {
      emit(FaceAuthFailure(e.toString()));
    }
  }

  Future<void> continueWithRD() async {
    emit(FaceAuthRdInitializing());
    try {
      final installed = await repository.isRdAppInstalled();
      if (!installed) {
        emit(FaceAuthFailure('RD service not installed'));
        return;
      }
      final result = await repository.startAadhaarRD();
      if (result.status == 'success') {
        emit(FaceAuthSuccess(result));
      } else {
        emit(FaceAuthFailure(result.message ?? 'RD failed'));
      }
    } catch (e) {
      emit(FaceAuthFailure(e.toString()));
    }
  }
}

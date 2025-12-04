import 'package:face_auth_sdk/src/helper/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../helper/faceauthhelper.dart';
import '../models/auth_session.dart';
import '../repository/face_auth_repository.dart';

part 'face_auth_state.dart';

class FaceAuthCubit extends Cubit<FaceAuthState> {
  final FaceAuthRepository repository;

  FaceAuthCubit(this.repository) : super(FaceAuthInitial());

  Future<void> startAuthentication({
    required String appId,
    Map<String, dynamic>? userData,
  }) async {
    emit(FaceAuthLoading());
    try {
      // 1) Attestation (this handles PI caching)
      final session = await repository.performAttestation(appId, userData);
      emit(FaceAuthOptions(session));
    } catch (e) {
      emit(FaceAuthFailure("Authentication",e.toString()));
    }
  }

  Future<void> continueWithRD() async {
    emit(FaceAuthRdInitializing());
    try {
      final installed = await repository.isRdAppInstalled(AppConstants.rdAppPackageProd);
      if (!installed) {
        emit(FaceAuthFailure('101','RD service not installed'));
        return;
      }
      final helper = FaceAuthHelper();
      final result = await helper.captureAndEncryptFaceXml(
        AppConstants.beneficiary,repository
      );
      if (result.isSuccess) {
        emit(FaceAuthSuccess(result));
      } else {
        emit(FaceAuthFailure(result.errorCode ?? '', result.errorMessage ?? 'FACE RD APP ERROR'));
      }
    } catch (e) {
      emit(FaceAuthFailure("RD Result",e.toString()));
    }
  }

}

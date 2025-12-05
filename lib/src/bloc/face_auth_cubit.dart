import 'package:face_auth_sdk/src/helper/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../data/models/afa_verification_request.dart';
import '../data/models/dashboard_request.dart';
import '../domain/useCases/attestation_uc.dart';
import '../domain/useCases/check_rdinstalled_uc.dart';
import '../domain/useCases/dashboard_uc.dart';
import '../domain/useCases/face_auth_req_uc.dart';
import '../domain/useCases/start_facerd_uc.dart';
import '../helper/faceauthhelper.dart';
import '../data/models/auth_session.dart';
import '../repository/face_auth_repository.dart';

part 'face_auth_state.dart';

class FaceAuthCubit extends Cubit<FaceAuthState> {
  final AttestationUseCase attestationUC;
  final DashboardUseCase dashboardUC;
  final CheckRdInstalledUseCase rdCheckUC;
  final StartFaceRdUseCase startRdUC;
  final FaceAuthRequestUseCase faceVerifyUC;

  FaceAuthCubit(
      this.attestationUC,
      this.dashboardUC,
      this.rdCheckUC,
      this.startRdUC,
      this.faceVerifyUC,
      ) : super(FaceAuthInitial());

  Future<void> startAuthentication({
    required String appId,
    Map<String, dynamic>? userData,
  }) async {
    emit(FaceAuthLoading());
    try {
      final session = await attestationUC(appId, userData);
      await dashboardUC(param: DashboardRequest(appCode: "", data: ""));
      emit(FaceAuthOptions(session));
    } catch (e) {
      emit(FaceAuthFailure("Authentication", e.toString()));
    }
  }

  Future<void> continueWithRD() async {
    emit(FaceAuthRdInitializing());

    try {
      final installed = await rdCheckUC(AppConstants.rdAppPackageProd);

      if (!installed) {
        emit(FaceAuthFailure('101', 'RD service not installed'));
        return;
      }

      final xml = await startRdUC("PID_OPTIONS_STRING");

      // call backend for verification
      final result = await faceVerifyUC(param: AfaVerificationRequest(
        pidData: xml,
        // other fields...
      ));

      result.fold(
            (failure) => emit(FaceAuthFailure(failure.errorCode, failure.message)),
            (success) {
              emit(FaceAuthSuccess(FaceAuthResult.success("encr")));
              },
      );
    } catch (e) {
      emit(FaceAuthFailure("RD Result", e.toString()));
    }
  }
}

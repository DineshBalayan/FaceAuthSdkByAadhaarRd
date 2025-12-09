import 'package:face_auth_sdk/src/helper/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../data/models/afa_verification_request.dart';
import '../data/models/auth_session.dart';
import '../data/models/dashboard_request.dart';
import '../domain/entities/dashboard_entity.dart';
import '../domain/useCases/attestation_uc.dart';
import '../domain/useCases/check_rdinstalled_uc.dart';
import '../domain/useCases/dashboard_uc.dart';
import '../domain/useCases/face_auth_req_uc.dart';
import '../domain/useCases/start_facerd_uc.dart';
import '../helper/faceauthhelper.dart';
import '../ui/auth_options_screen.dart';

part 'face_auth_state.dart';

class FaceAuthCubit extends Cubit<FaceAuthState> {
  final AttestationUseCase attestationUC;
  final DashboardUseCase dashboardUC;
  final CheckRdInstalledUseCase rdCheckUC;
  final StartFaceRdUseCase startRdUC;
  final FaceAuthRequestUseCase faceVerifyUC;

  final String appCode;
  final String userData;

  FaceAuthCubit(
    this.attestationUC,
    this.dashboardUC,
    this.rdCheckUC,
    this.startRdUC,
    this.faceVerifyUC, {
    required this.appCode,
    required this.userData,
  }) : super(FaceAuthInitial());

  Future<void> startAuthentication({
    required String appId,
    Map<String, dynamic>? userDataMap,
  }) async {
    try {
      emit(
        FaceAuthProgress(
          step: FaceAuthStep.initializing,
          message: "Initializing SDK...",
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        FaceAuthProgress(
          step: FaceAuthStep.attestationCheck,
          message: "Verifying app integrity...",
        ),
      );

      final session = await attestationUC(appId, userDataMap);
      // ✅ store internally
      var _session = session;

      emit(
        FaceAuthProgress(
          step: FaceAuthStep.dashboardCall,
          message: "Fetching dashboard config...",
          session: session,
        ),
      );

      final result = await dashboardUC(
        param: DashboardRequest(appCode: appCode, data: userData),
      );
      result.fold(
        (failure) {
          emit(
            FaceAuthFailure(
              failure.errorCode,
              failure.message.toString().split(':')[0],
            ),
          );
        },
        (entity) {
          emit(
            FaceAuthOptions(
              session: session,
              dashboard: entity,
            ),
          );
        },
      );
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

      final helper = FaceAuthHelper();

      final rdResult = await helper.captureAndEncryptFaceXml(
        userType: AppConstants.beneficiary,
        startRdUC: startRdUC,
      );

      if (!rdResult.isSuccess) {
        emit(
          FaceAuthFailure(
            rdResult.errorCode ?? '',
            rdResult.errorMessage ?? 'RD Error',
          ),
        );
        return;
      }

      final apiResult = await faceVerifyUC(
        param: AfaVerificationRequest(
          pidData: rdResult.encryptedPid,
          // other fields...
        ),
      );

      apiResult.fold(
        (failure) => emit(FaceAuthFailure(failure.errorCode, failure.message)),
        (_) => emit(FaceAuthSuccess(rdResult)),
      );
    } catch (e) {
      emit(FaceAuthFailure('RD Result', e.toString()));
    }
  }
}

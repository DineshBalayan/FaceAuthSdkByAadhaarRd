import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../aadhaar_auth_sdk.dart';
import '../data/models/auth_session.dart';
import '../domain/useCases/attestation_uc.dart';
import '../domain/useCases/check_rdinstalled_uc.dart';
import '../domain/useCases/dashboard_uc.dart';
import '../domain/useCases/face_auth_req_uc.dart';
import '../domain/useCases/start_facerd_uc.dart';
import '../domain/entities/aadhaar_auth_step.dart';
import '../domain/entities/dashboard_entity.dart';
import '../data/models/dashboard_request.dart';
import '../helper/constants/app_constants.dart';
import '../helper/faceauthhelper.dart';
import '../data/models/afa_verification_request.dart';

part 'aadhaar_auth_state.dart';

class AadhaarAuthCubit extends Cubit<AadhaarAuthState> {
  final AttestationUseCase attestationUC;
  final DashboardUseCase dashboardUC;
  final CheckRdInstalledUseCase rdCheckUC;
  final StartFaceRdUseCase startRdUC;
  final FaceAuthRequestUseCase faceVerifyUC;

  final String appCode;
  final String userData;

  AadhaarAuthCubit(
    this.attestationUC,
    this.dashboardUC,
    this.rdCheckUC,
    this.startRdUC,
    this.faceVerifyUC, {
    required this.appCode,
    required this.userData,
  }) : super(AadhaarAuthInitial());

  Future<void> startAuthentication({
    required String appId,
    Map<String, dynamic>? userDataMap,
  }) async {
    try {
      emit(
        AadhaarAuthProgress(
          step: AadhaarAuthStep.initializing,
          message: "Initializing SDK...",
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        AadhaarAuthProgress(
          step: AadhaarAuthStep.attestationCheck,
          message: "Verifying app integrity...",
        ),
      );

      final session = await attestationUC(appId, userDataMap);
      emit(
        AadhaarAuthProgress(
          step: AadhaarAuthStep.dashboardCall,
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
            AadhaarAuthFailure(
              failure.errorCode,
              failure.message.toString().split(':')[0],
            ),
          );
        },
        (entity) {
          emit(
            AadhaarAuthOptions(
              session: session,
              dashboard: entity,
            ),
          );
        },
      );
    } catch (e) {
      emit(AadhaarAuthFailure("Authentication", e.toString()));
    }
  }

  Future<void> continueWithRD() async {
    emit(AadhaarAuthRdInitializing());

    try {
      final installed = await rdCheckUC(AppConstants.rdAppPackageProd);
      if (!installed) {
        emit(AadhaarAuthFailure('101', 'RD service not installed'));
        return;
      }

      final helper = FaceAuthHelper();

      final rdResult = await helper.captureAndEncryptFaceXml(
        userType: AppConstants.beneficiary,
        startRdUC: startRdUC,
      );

      if (!rdResult.isSuccess) {
        emit(
          AadhaarAuthFailure(
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
        (failure) => emit(AadhaarAuthFailure(failure.errorCode, failure.message)),
        (_) => emit(FaceAuthSuccess(rdResult)),
      );
    } catch (e) {
      emit(AadhaarAuthFailure('RD Result', e.toString()));
    }
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repository/server_repository.dart';
import '../../face_auth_sdk_platform_interface.dart';
import '../../helper/constants/api_urls.dart';
import '../../helper/error/exception.dart';
import '../../helper/error/failure.dart';
import '../../helper/l10n/string_keys.dart';
import '../../network/dio_client.dart';
import '../models/afa_verification_request.dart';
import '../models/auth_session.dart';
import '../models/dashboard_request.dart';
import '../models/response/afa_verify_response.dart';
import '../models/response/dashboard_response.dart';

class ServerRepositoryImpl implements ServerRepository {
  final DioClient dioClient;
  final FaceAuthSdkPlatform _platform = FaceAuthSdkPlatform.instance;

  ServerRepositoryImpl(this.dioClient);

  // ---------------------------
  //      DASHBOARD LOAD
  // ---------------------------
  @override
  Future<Either<Failure, DashboardEntity>> dashboardLoad(
    DashboardRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiUrls.authService,
        data: request.toJson(),
      );

      final result = DashboardResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      return Right(result.toEntity());
    } on DioException catch (e) {
      String message = e.message ?? 'Oops! Getting Error';
      String errorCode = 'Status:-${e.response?.statusCode ?? 0}';

      if (e.error is SocketException) {
        errorCode = StringKeys.noInternet;
        message = StringKeys.networkIssue;
      }

      return Left(ServerFailure(errorCode: errorCode, message: message));
    }
  }

  // ---------------------------
  //      FACE AUTH VERIFY
  // ---------------------------
  @override
  Future<Either<Failure, AfaVerifyResponse>> faceAuthRequest(
    AfaVerificationRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiUrls.faceAuthRequest,
        data: request.toJson(),
      );

      final parsed = AfaVerifyResponse.fromJson(response.data);

      if (!parsed.isSuccess) {
        return Left(
          ServerFailure(
            errorCode: 'Face Authentication Failed',
            message: parsed.message,
          ),
        );
      }

      return Right(parsed);
    } on DioException catch (e) {
      String message = e.message ?? 'Face Authentication Failed';
      final errorCode = e.error ?? 'Face Authentication Failed';

      if (e.error is SocketException) {
        message = StringKeys.networkIssue;
      }

      return Left(
        ServerFailure(errorCode: errorCode.toString(), message: message),
      );
    }
  }

  // ---------------------------
  //     PLATFORM ATTESTATION
  // ---------------------------
  @override
  Future<AuthSession> performAttestation(
    String appId,
    Map<String, dynamic>? userData,
  ) async {
    final res = await _platform.startAuthentication();

    if (res == null || res['status'] != 'success') {
      throw Exception(res?['message'] ?? 'attestation_failed');
    }

    return AuthSession.fromMap(res);
  }

  // ---------------------------
  //   CHECK RD APP INSTALLATION
  // ---------------------------
  @override
  Future<bool> isRdAppInstalled(String packageName) async {
    final r = await _platform.isRdAppInstalled(packageName);
    return r ?? false;
  }

  // ---------------------------
  //     CALL RD SERVICE
  // ---------------------------
  @override
  Future<String?> startFaceRD(String pidOptions) async {
    try {
      return await _platform.startAadhaarRD(pidOptions);
    } on PlatformException catch (e) {
      debugPrint("PlatformException in RD start: ${e.message}");
      throw ServerException(e.code, e.message ?? "Native RD error (unknown)");
    } catch (e) {
      ServerException serExp = ServerException(
        e is ServerException ? e.errorCode : 'UNKNOWN',
        e is ServerException ? e.message : e.toString(),
      );

      debugPrint("Unexpected RD error: ${serExp.message}");

      throw serExp;
    }
  }

  // ---------------------------
  //  SERVER INTEGRITY VERIFY
  // ---------------------------
  @override
  Future<Map<String, dynamic>> verifyIntegrityOnServer(
    String integrityToken,
    String backendBaseUrl,
  ) async {
    // Implement integrator-side HTTP here
    throw UnimplementedError(
      'Call backend POST /v1/auth/integrity/verify here',
    );
  }
}

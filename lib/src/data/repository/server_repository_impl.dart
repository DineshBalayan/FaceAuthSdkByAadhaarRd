import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repository/server_repository.dart';
import '../../helper/constants/api_urls.dart';
import '../../helper/error/failure.dart';
import '../../helper/l10n/string_keys.dart';
import '../../network/dio_client.dart';
import '../models/afa_verification_request.dart';
import '../models/dashboard_request.dart';
import '../models/response/dashboard_response.dart';
import '../models/response/afa_verify_response.dart';

class ServerRepositoryImpl implements ServerRepository {
  final DioClient dioClient;

  ServerRepositoryImpl(this.dioClient);

  @override
  Future<Either<Failure, DashboardEntity>> dashboardLoad(
    DashboardRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiUrls.dashboard,
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
      return Left(
        ServerFailure(errorCode: errorCode.toString(), message: message),
      );
    }
  }

  @override
  Future<Either<Failure, AfaVerifyResponse>> faceAuthRequest(
    AfaVerificationRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        ApiUrls.faceAuthRequest,
        data: request.toJson(),
      );
      // await getIt<LocalRepository>().saveTestData(response.data.toString());
      final parsed = AfaVerifyResponse.fromJson(response.data);
      if (!parsed.isSuccess) {
        return Left(
          ServerFailure(
            errorCode: 'Face Authentication Failed',
            message: parsed.message,
          ),
        );
      } else {
        return Right(parsed);
      }
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
}

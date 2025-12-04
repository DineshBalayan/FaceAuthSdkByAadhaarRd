
import 'dart:convert';
import 'dart:math';
import 'package:face_auth_sdk/src/repository/face_auth_repository.dart';
import 'package:xml2json/xml2json.dart';

import 'app_constants.dart';

class FaceAuthHelper {

  Future<FaceAuthResult> captureAndEncryptFaceXml(int userType, FaceAuthRepository repository) async {
    try {
      final txnId = generateRandomTxnId();
      final pidOptions = buildPidOptionsXml(txnId, userType);
      final pidXml = await repository.startFaceRD(pidOptions);
      if (pidXml == null || pidXml.isEmpty) {
        return FaceAuthResult.failure(
          'PID Data Exception',
          "FaceRD returned empty or null XML.",
        );
      }

      // ✅ Validate RD response using internal method
      final parsedError = _extractRDResultError(pidXml);
      if (parsedError != null) {
        return FaceAuthResult.failure(parsedError.errCode, parsedError.errInfo);
      }
      return FaceAuthResult.success(pidXml);
    } catch (e) {
      return FaceAuthResult.failure(
        "RD Exception",e.toString()
      );
    }
  }

  /// Handles error extraction from raw RD XML
  _RDServiceError? _extractRDResultError(String pidXml) {
    try {
      final xml2json = Xml2Json();
      xml2json.parse(pidXml);

      // Use GData format to retain attributes
      final jsonString = xml2json.toGData();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final resp = data['PidData']?['Resp'];
      final errCode = resp?['errCode']?.toString();
      final errInfo = resp?['errInfo']?.toString();

      if (errCode != null && errCode != "0") {
        return _RDServiceError(
          errCode: errCode,
          errInfo: errInfo ?? "Unknown error",
        );
      }
      return null;
    } catch (_) {
      return _RDServiceError(
        errCode: "Parsing Error",
        errInfo: "Invalid PID XML or Parse Error",
      );
    }
  }

// TODO: check env="P" for Prod version
  String buildPidOptionsXml(String txnId, int userType) {
    String wadh = userType == AppConstants.eMitra
        ? 'HzHcM1lgshaAElEgZPz8LrzBeugY9KQ/NMuunxOxtSE='
        : '';
    return '''<?xml version="1.0" encoding="UTF-8"?>
<PidOptions ver="1.0" env="PP">
   <Opts format="" pidVer="2.0" otp="" wadh="$wadh" />
   <CustOpts>
      <Param name="txnId" value="$txnId"/>
      <Param name="purpose" value="auth"/>
      <Param name="language" value="en"/>
   </CustOpts>
</PidOptions>''';
  }

  String generateRandomTxnId() {
    final random = Random();
    return List.generate(12, (_) => random.nextInt(10)).join();
  }
}

class FaceAuthResult {
  final bool isSuccess;
  final String? encryptedPid;
  final String? errorCode;
  final String? errorMessage;

  FaceAuthResult.success(this.encryptedPid)
    : isSuccess = true,
      errorCode = null,
      errorMessage = null;

  FaceAuthResult.failure(this.errorCode, this.errorMessage)
    : isSuccess = false,
      encryptedPid = null;
}

class _RDServiceError {
  final String errCode;
  final String errInfo;

  _RDServiceError({required this.errCode, required this.errInfo});
}

class RDResult {
  final bool isSuccess;
  final String errCode;
  final String errInfo;

  RDResult({
    required this.isSuccess,
    required this.errCode,
    required this.errInfo,
  });

  factory RDResult.fromJson(Map<String, dynamic>? json) {
    final resp = json?['PidData']?['Resp'] as Map<String, dynamic>?;

    final errCode = resp?['errCode']?.toString() ?? 'NA';
    final errInfo = resp?['errInfo']?.toString() ?? 'Unknown Error';

    return RDResult(
      isSuccess: errCode == '0',
      errCode: errCode,
      errInfo: errInfo,
    );
  }
}

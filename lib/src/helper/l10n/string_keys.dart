import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

class StringKeys {
  static BuildContext? _context;

  /// Initialize this once in MaterialApp.builder or root widget
  static void setContext(BuildContext context) {
    _context = context;
  }

  static AppLocalizations get _loc {
    if (_context == null) {
      throw Exception(
        "StringKeys context not set. Call StringKeys.setContext(context) in MaterialApp.builder.",
      );
    }
    return AppLocalizations.of(_context!)!;
  }

  // Aadhaar-related
  static String get aadhaarConsentEn => _loc.aadhaarConsentEn;

  static String get aadhaarConsentHi => _loc.aadhaarConsentHi;

  static String get requestConsentEn => _loc.requestConsentEn;

  static String get requestConsentHi => _loc.requestConsentHi;

  static String get dashboardConsent => _loc.dashboardConsent;

  // Common tags
  static String get purposeTag => _loc.purposeTag;

  static String get deptTag => _loc.deptTag;

  static String get english => _loc.english;

  static String get hindi => _loc.hindi;

  // App/version info
  static String get appVersionTitle => _loc.appVersionTitle;

  static String get threatTitle => _loc.threatTitle;

  static String get appVersionMsg => _loc.appVersionMsg;

  // Registration
  static String get notRegisterTitle => _loc.notRegisterTitle;

  static String get notRegisterMsg => _loc.notRegisterMsg;

  static String get registration => _loc.registration;

  static String get register => _loc.register;

  static String get registrationSuccessful => _loc.registrationSuccessful;

  static String get registrationSuccessMsg => _loc.registrationSuccessMsg;

  static String get registerAsBeneficiary => _loc.registerAsBeneficiary;

  static String get registerAsEMitra => _loc.registerAsEMitra;

  // Login / auth
  static String get afa => _loc.afa;

  static String get login => _loc.login;

  static String get userLogin => _loc.userLogin;

  static String get doITFaceAuthentication => _loc.doITFaceAuthentication;

  static String get loginWithAadhaar => _loc.loginWithAadhaar;

  static String get loginWithSso => _loc.loginWithSso;

  static String get loginSuccessfully => _loc.loginSuccessfully;

  static String get logout => _loc.logout;

  static String get makeSureLogout => _loc.makeSureLogout;

  static String get confirm => _loc.confirm;

  static String get yesConfirm => _loc.yesConfirm;

  static String get noCancel => _loc.noCancel;

  static String get ok => _loc.ok;

  static String get cancel => _loc.cancel;

  static String get forgotPwd => _loc.forgotPwd;

  static String get password => _loc.password;

  static String get keepMeLoggedIn => _loc.keepMeLoggedIn;

  static String get missingSsoId => _loc.missingSsoId;

  static String get missingPwd => _loc.missingPwd;

  static String get authSuccess => _loc.authSuccess;

  // Fields / validation
  static String get detail => _loc.detail;

  static String get update => _loc.update;

  static String get exit => _loc.exit;

  static String get reports => _loc.reports;

  static String get aadhaarFieldValidation => _loc.aadhaarFieldValidation;

  static String get nameFieldValidation => _loc.nameFieldValidation;

  static String get mobileFieldValidation => _loc.mobileFieldValidation;

  static String get consentFieldValidation => _loc.consentFieldValidation;

  static String get kioskCode => _loc.kioskCode;

  static String get ssoId => _loc.ssoId;

  static String get enterKioskCode => _loc.enterKioskCode;

  static String get enterSsoId => _loc.enterSsoId;

  static String get name => _loc.name;

  static String get enterName => _loc.enterName;

  static String get mobileNumber => _loc.mobileNumber;

  static String get enterMobileNumber => _loc.enterMobileNumber;

  static String get refAadhaarNumber => _loc.refAadhaarNumber;

  static String get enterAadhaarNo => _loc.enterAadhaarNo;

  // Errors / alerts
  static String get aadhaarConsentAlert => _loc.aadhaarConsentAlert;

  static String get aadhaarNumberAlert => _loc.aadhaarNumberAlert;

  static String get tokenError => _loc.tokenError;

  static String get noInternet => _loc.noInternet;

  static String get networkIssue => _loc.networkIssue;

  static String get errorCode => _loc.errorCode;

  static String get noFaceAuthRequestPending => _loc.noFaceAuthRequestPending;

  static String get deviceNotSupported => _loc.deviceNotSupported;

  static String get deviceNotSupportedMsg => _loc.deviceNotSupportedMsg;

  static String get authenticateToContinue => _loc.authenticateToContinue;

  static String get authenticateFailed => _loc.authenticateFailed;

  static String get biometricErrorTag => _loc.biometricErrorTag;

  static String get biometricSetupError => _loc.biometricSetupError;

  static String get biometricSetupErrorMsg => _loc.biometricSetupErrorMsg;

  // Aadhaar / request info
  static String get verify => _loc.verify;

  static String get pendingReq => _loc.pendingReq;

  static String get aadhaar => _loc.aadhaar;

  static String get aadhaarNo => _loc.aadhaarNo;

  static String get departmentName => _loc.departmentName;

  static String get purpose => _loc.purpose;

  static String get requestID => _loc.requestID;

  static String get referenceId => _loc.referenceId;

  static String get request => _loc.request;

  static String get requestType => _loc.requestType;

  static String get timeStamp => _loc.timeStamp;

  static String get dateTime => _loc.dateTime;

  static String get departmentNameReport => _loc.departmentNameReport;

  static String get dateTimeReport => _loc.dateTimeReport;

  static String get requestTypeReport => _loc.requestTypeReport;

  static String get aadhaarNoShort => _loc.aadhaarNoReport;

  // RD app
  static String get faceRdNotFound => _loc.faceRdNotFound;

  static String get rdAppMissingAlert => _loc.rdAppMissingAlert;

  static String get faceRDApp => _loc.faceRDApp;

  static String get faceAuthRDDownload => _loc.faceAuthRDDownload;

  static String get faceAuthRDAlready => _loc.faceAuthRDAlready;

  static String get faceAuthLocked => _loc.faceAuthLocked;

  // Biometrics
  static String get biometricSettings => _loc.biometricSettings;

  static String get enableBiometric => _loc.enableBiometric;

  static String get unlockBiometric => _loc.unlockBiometric;

  static String get byEnable => _loc.byEnable;

  static String get biometricMsg => _loc.biometricMsg;

  // Misc UI
  static String get home => _loc.home;

  static String get updateApp => _loc.updateApp;

  static String get downloadFaceRD => _loc.downloadFaceRD;

  static String get aboutUs => _loc.aboutUs;

  static String get rateUs => _loc.rateUs;

  static String get appVersion => _loc.appVersion;

  static String get aadhaarBasedAuth => _loc.aadhaarBasedAuth;

  static String get ratingMsg => _loc.ratingMsg;

  static String get rateOnGooglePlay => _loc.rateOnGooglePlay;

  static String get noThanks => _loc.noThanks;

  static String get thanks => _loc.thanks;

  static String get noDataFound => _loc.noDataFound;

  static String get enterCaptcha => _loc.enterCaptcha;

  static String get plzEnterValidCaptcha => _loc.plzEnterValidCaptcha;

  static String get playHint => _loc.playHint;

  static String get splashMsg => _loc.splashMsg;

  static String get changeLang => _loc.changeLang;

  static String get operator => _loc.operator;

  static String get beneficiary => _loc.beneficiary;

  static String get usbDebugEnabled => _loc.usbDebugEnabled;

  static String get unsafeEnvFound => _loc.unsafeEnvFound;

  static String get deviceFridaRoot => _loc.deviceFridaRoot;

  static String get deviceRooted => _loc.deviceRooted;

  static String get deviceEmulator => _loc.deviceEmulator;

  static String get mockLocEnabled => _loc.mockLocEnabled;

  static String get fakeLocation => _loc.fakeLocation;

  static String get downloadRdByLink => _loc.downloadRdByLink;

  static String get locDisable => _loc.locDisable;

  static String get locPermissionDeny => _loc.locPermissionDeny;

  static String get locPermanentDeny => _loc.locPermanentDeny;

  static String get locFetchFailed => _loc.locFetchFailed;

  static String get checkTerms => _loc.checkTerms;

  static String get viewConsent => _loc.viewConsent;

  static String get doitGoR => _loc.doitGoR;
}

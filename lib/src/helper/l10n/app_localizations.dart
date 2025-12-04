import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @aadhaarConsentEn.
  ///
  /// In en, this message translates to:
  /// **'I (Parents/Legal Guardian, in case of minor) hereby provide my consent for the use of my Aadhaar number to perform Aadhaar based Face authentication with UIDAI for Login/Registration on DoIT&C Face Authentication mobile app. Upon successful Aadhaar based Face Authentication (Yes/No response), I provide consent to get myself registered on DoIT&C Face Authentication mobile App to use its features. I have voluntarily chosen Aadhaar based Face authentication. I also provide my explicit consent to securely store my Aadhaar number and response of Aadhaar authentication transaction.'**
  String get aadhaarConsentEn;

  /// No description provided for @aadhaarConsentHi.
  ///
  /// In en, this message translates to:
  /// **'मैं (माता-पिता/कानूनी अभिभावक, यदि नाबालिग हो) स्वेच्छा से अपनी सहमति प्रदान करता/करती हूँ कि मेरे आधार संख्या का उपयोग DoIT&C फेस ऑथेंटिकेशन मोबाइल ऐप पर लॉगिन/पंजीकरण हेतु, भारतीय विशिष्ट पहचान प्राधिकरण (UIDAI) के माध्यम से आधार आधारित चेहरे के प्रमाणीकरण के लिए किया जाए। प्रमाणीकरण की प्रक्रिया में प्राप्त \"हाँ/ना\" उत्तर के आधार पर, मैं स्वयं को DoIT&C फेस ऑथेंटिकेशन मोबाइल ऐप पर पंजीकृत करने हेतु सहमति प्रदान करता/करती हूँ, जिससे ऐप की सेवाओं का उपयोग किया जा सके। मैं आधार आधारित चेहरे के प्रमाणीकरण का चयन स्वेच्छा से कर रहा/रही हूँ। साथ ही, मैं अपनी स्पष्ट सहमति देता/देती हूँ कि मेरी आधार संख्या एवं आधार प्रमाणीकरण लेन-देन की प्रतिक्रिया को सुरक्षित रूप से संग्रहीत किया जाए।'**
  String get aadhaarConsentHi;

  /// No description provided for @requestConsentEn.
  ///
  /// In en, this message translates to:
  /// **'I (Parents/Legal Guardian, in case of minor) hereby provide my consent for the use of my Aadhaar number to perform Aadhaar based Face authentication on DoIT&C Face Authentication mobile app with UIDAI for <Purpose> for availing the services of <Department>. The department has informed me that my Aadhaar shall not be used for any purpose other than mentioned above. I have voluntarily chosen Aadhaar based Face authentication. I also provide my explicit consent to securely store my Aadhaar number and response of Aadhaar authentication transaction.'**
  String get requestConsentEn;

  /// No description provided for @requestConsentHi.
  ///
  /// In en, this message translates to:
  /// **'मैं (माता-पिता/कानूनी अभिभावक, यदि नाबालिग हो) स्वेच्छा से अपनी सहमति प्रदान करता/करती हूँ कि मेरी आधार संख्या का उपयोग DoIT&C फेस ऑथेंटिकेशन मोबाइल ऐप पर भारतीय विशिष्ट पहचान प्राधिकरण (UIDAI) के माध्यम से <Purpose> हेतु आधार आधारित चेहरे के प्रमाणीकरण के लिए किया जाए, ताकि मैं <Department> की सेवाओं का लाभ प्राप्त कर सकूँ। विभाग द्वारा मुझे सूचित किया गया है कि मेरी आधार जानकारी का उपयोग उपर्युक्त उद्देश्य के अतिरिक्त किसी अन्य कार्य हेतु नहीं किया जाएगा। मैंने स्वेच्छा से आधार आधारित चेहरे के प्रमाणीकरण का चयन किया है। इसके अतिरिक्त, मैं अपनी स्पष्ट सहमति प्रदान करता/करती हूँ कि मेरी आधार संख्या एवं प्रमाणीकरण लेन-देन की प्रतिक्रिया को सुरक्षित रूप से संग्रहीत किया जाए।'**
  String get requestConsentHi;

  /// No description provided for @dashboardConsent.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar face authentication is based on 1:1 (exact) matching. This means that the face image captured during authentication is matched with the face image stored in the Aadhaar repository against your Aadhaar number, which was taken at the time of enrolment.'**
  String get dashboardConsent;

  /// No description provided for @purposeTag.
  ///
  /// In en, this message translates to:
  /// **'<Purpose>'**
  String get purposeTag;

  /// No description provided for @deptTag.
  ///
  /// In en, this message translates to:
  /// **'<Department>'**
  String get deptTag;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @appVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Version Available'**
  String get appVersionTitle;

  /// No description provided for @threatTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Threat'**
  String get threatTitle;

  /// No description provided for @appVersionMsg.
  ///
  /// In en, this message translates to:
  /// **'Please download the new version of the application'**
  String get appVersionMsg;

  /// No description provided for @notRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome User'**
  String get notRegisterTitle;

  /// No description provided for @notRegisterMsg.
  ///
  /// In en, this message translates to:
  /// **'New Registration\n\nYou are not registered. Please proceed for registration in this app.'**
  String get notRegisterMsg;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @afa.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Face Authentication'**
  String get afa;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detail;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @noCancel.
  ///
  /// In en, this message translates to:
  /// **'No, Cancel'**
  String get noCancel;

  /// No description provided for @yesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Confirm'**
  String get yesConfirm;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @pendingReq.
  ///
  /// In en, this message translates to:
  /// **'Pending Request'**
  String get pendingReq;

  /// No description provided for @makeSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get makeSureLogout;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Confirm'**
  String get confirm;

  /// No description provided for @registerAsBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Register as Beneficiary'**
  String get registerAsBeneficiary;

  /// No description provided for @registerAsEMitra.
  ///
  /// In en, this message translates to:
  /// **'Register as eMitra'**
  String get registerAsEMitra;

  /// No description provided for @aadhaarFieldValidation.
  ///
  /// In en, this message translates to:
  /// **'Please update aadhaar number in SSO profile'**
  String get aadhaarFieldValidation;

  /// No description provided for @nameFieldValidation.
  ///
  /// In en, this message translates to:
  /// **'Please update Name SSO profile'**
  String get nameFieldValidation;

  /// No description provided for @mobileFieldValidation.
  ///
  /// In en, this message translates to:
  /// **'Please update Mobile number in SSO profile'**
  String get mobileFieldValidation;

  /// No description provided for @consentFieldValidation.
  ///
  /// In en, this message translates to:
  /// **'Please Check Aadhaar consent'**
  String get consentFieldValidation;

  /// No description provided for @kioskCode.
  ///
  /// In en, this message translates to:
  /// **'Kiosk Code'**
  String get kioskCode;

  /// No description provided for @ssoId.
  ///
  /// In en, this message translates to:
  /// **'SSO ID'**
  String get ssoId;

  /// No description provided for @enterKioskCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Kiosk Code'**
  String get enterKioskCode;

  /// No description provided for @enterSsoId.
  ///
  /// In en, this message translates to:
  /// **'Enter SSO ID'**
  String get enterSsoId;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile No.'**
  String get enterMobileNumber;

  /// No description provided for @refAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Ref/Aadhaar No.'**
  String get refAadhaarNumber;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Registration Success'**
  String get registrationSuccessful;

  /// No description provided for @registrationSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Registration successful. Click OK to proceed to login.'**
  String get registrationSuccessMsg;

  /// No description provided for @faceRdNotFound.
  ///
  /// In en, this message translates to:
  /// **'FaceRD Not Found'**
  String get faceRdNotFound;

  /// No description provided for @rdAppMissingAlert.
  ///
  /// In en, this message translates to:
  /// **'This service requires the FaceRD app. Do you want to install it from Play Store?'**
  String get rdAppMissingAlert;

  /// No description provided for @userLogin.
  ///
  /// In en, this message translates to:
  /// **'User Login'**
  String get userLogin;

  /// No description provided for @doITFaceAuthentication.
  ///
  /// In en, this message translates to:
  /// **'DoIT&C Face Authentication'**
  String get doITFaceAuthentication;

  /// No description provided for @loginWithAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Login with Aadhaar No.'**
  String get loginWithAadhaar;

  /// No description provided for @loginWithSso.
  ///
  /// In en, this message translates to:
  /// **'Login with SSO ID'**
  String get loginWithSso;

  /// No description provided for @loginSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loginSuccessfully;

  /// No description provided for @enterAadhaarNo.
  ///
  /// In en, this message translates to:
  /// **'Enter Aadhaar No.'**
  String get enterAadhaarNo;

  /// No description provided for @aadhaarConsentAlert.
  ///
  /// In en, this message translates to:
  /// **'Please check the Aadhaar consent checkbox to continue.'**
  String get aadhaarConsentAlert;

  /// No description provided for @aadhaarNumberAlert.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 12-digit Aadhaar number.'**
  String get aadhaarNumberAlert;

  /// No description provided for @tokenError.
  ///
  /// In en, this message translates to:
  /// **'Invalid Token or Expired : Re Login'**
  String get tokenError;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @aadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar'**
  String get aadhaar;

  /// No description provided for @aadhaarNo.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNo;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get departmentName;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @requestID.
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestID;

  /// No description provided for @referenceId.
  ///
  /// In en, this message translates to:
  /// **'Reference Id'**
  String get referenceId;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @requestType.
  ///
  /// In en, this message translates to:
  /// **'Request Type'**
  String get requestType;

  /// No description provided for @timeStamp.
  ///
  /// In en, this message translates to:
  /// **'Time Stamp'**
  String get timeStamp;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @errorCode.
  ///
  /// In en, this message translates to:
  /// **'Error Code'**
  String get errorCode;

  /// No description provided for @noFaceAuthRequestPending.
  ///
  /// In en, this message translates to:
  /// **'No Face Auth Request Pending !!'**
  String get noFaceAuthRequestPending;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get dateTime;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @updateApp.
  ///
  /// In en, this message translates to:
  /// **'Update App'**
  String get updateApp;

  /// No description provided for @downloadFaceRD.
  ///
  /// In en, this message translates to:
  /// **'Download Face RD'**
  String get downloadFaceRD;

  /// No description provided for @biometricSettings.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock Setting'**
  String get biometricSettings;

  /// No description provided for @enableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric'**
  String get enableBiometric;

  /// No description provided for @unlockBiometric.
  ///
  /// In en, this message translates to:
  /// **'Unlock with biometric'**
  String get unlockBiometric;

  /// No description provided for @byEnable.
  ///
  /// In en, this message translates to:
  /// **'When enabled, biometric app lock will be activated. You can turn this feature on or off anytime'**
  String get byEnable;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @forgotPwd.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPwd;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @keepMeLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Keep me logged in'**
  String get keepMeLoggedIn;

  /// No description provided for @missingSsoId.
  ///
  /// In en, this message translates to:
  /// **'Please Enter SSO ID'**
  String get missingSsoId;

  /// No description provided for @missingPwd.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Password'**
  String get missingPwd;

  /// No description provided for @authSuccess.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Face Authentication Successful'**
  String get authSuccess;

  /// No description provided for @faceRDApp.
  ///
  /// In en, this message translates to:
  /// **'FaceRD App'**
  String get faceRDApp;

  /// No description provided for @faceAuthRDDownload.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Face RD service app not found so download app from store'**
  String get faceAuthRDDownload;

  /// No description provided for @faceAuthRDAlready.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Face RD App already Installed'**
  String get faceAuthRDAlready;

  /// No description provided for @faceAuthLocked.
  ///
  /// In en, this message translates to:
  /// **'FaceAuth Locked'**
  String get faceAuthLocked;

  /// No description provided for @biometricMsg.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric login for quicker and secure access using your fingerprint or face.'**
  String get biometricMsg;

  /// No description provided for @aadhaarBasedAuth.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Based Face Authentication'**
  String get aadhaarBasedAuth;

  /// No description provided for @ratingMsg.
  ///
  /// In en, this message translates to:
  /// **'we will work harder to make you more satisfied.'**
  String get ratingMsg;

  /// No description provided for @rateOnGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Rate on Google Play'**
  String get rateOnGooglePlay;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No, Thanks!'**
  String get noThanks;

  /// No description provided for @thanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks!'**
  String get thanks;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found !!'**
  String get noDataFound;

  /// No description provided for @splashMsg.
  ///
  /// In en, this message translates to:
  /// **'Department of Information Technology\n& Communication, Government of Rajasthan'**
  String get splashMsg;

  /// No description provided for @enterCaptcha.
  ///
  /// In en, this message translates to:
  /// **'Enter Captcha'**
  String get enterCaptcha;

  /// No description provided for @plzEnterValidCaptcha.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid Captcha'**
  String get plzEnterValidCaptcha;

  /// No description provided for @networkIssue.
  ///
  /// In en, this message translates to:
  /// **'Network Issue, Try again later'**
  String get networkIssue;

  /// No description provided for @deviceNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Device not supported'**
  String get deviceNotSupported;

  /// No description provided for @deviceNotSupportedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your device does not support biometric authentication.'**
  String get deviceNotSupportedMsg;

  /// No description provided for @authenticateToContinue.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to continue'**
  String get authenticateToContinue;

  /// No description provided for @authenticateFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticateFailed;

  /// No description provided for @biometricErrorTag.
  ///
  /// In en, this message translates to:
  /// **'Biometric error:'**
  String get biometricErrorTag;

  /// No description provided for @biometricSetupError.
  ///
  /// In en, this message translates to:
  /// **'Biometrics aren\"t set up'**
  String get biometricSetupError;

  /// No description provided for @biometricSetupErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'To enable this feature, please set up Face or Fingerprint unlock in your device settings.'**
  String get biometricSetupErrorMsg;

  /// No description provided for @aadhaarNoReport.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar No.'**
  String get aadhaarNoReport;

  /// No description provided for @departmentNameReport.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get departmentNameReport;

  /// No description provided for @dateTimeReport.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get dateTimeReport;

  /// No description provided for @requestTypeReport.
  ///
  /// In en, this message translates to:
  /// **'Request Type'**
  String get requestTypeReport;

  /// No description provided for @playHint.
  ///
  /// In en, this message translates to:
  /// **'How to Login?👇'**
  String get playHint;

  /// No description provided for @changeLang.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLang;

  /// No description provided for @operator.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get operator;

  /// No description provided for @beneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiary;

  /// No description provided for @usbDebugEnabled.
  ///
  /// In en, this message translates to:
  /// **'Detected unsafe environment due to: Device is in Usb Debugging mode.'**
  String get usbDebugEnabled;

  /// No description provided for @unsafeEnvFound.
  ///
  /// In en, this message translates to:
  /// **'Detected unsafe environment due to'**
  String get unsafeEnvFound;

  /// No description provided for @deviceFridaRoot.
  ///
  /// In en, this message translates to:
  /// **'Device Found Frida/Rooted.'**
  String get deviceFridaRoot;

  /// No description provided for @deviceRooted.
  ///
  /// In en, this message translates to:
  /// **'Device found rooted.'**
  String get deviceRooted;

  /// No description provided for @deviceEmulator.
  ///
  /// In en, this message translates to:
  /// **'Device is Emulator.'**
  String get deviceEmulator;

  /// No description provided for @mockLocEnabled.
  ///
  /// In en, this message translates to:
  /// **'Device enabled mock location.'**
  String get mockLocEnabled;

  /// No description provided for @fakeLocation.
  ///
  /// In en, this message translates to:
  /// **'Fake Location'**
  String get fakeLocation;

  /// No description provided for @downloadRdByLink.
  ///
  /// In en, this message translates to:
  /// **'Download from play store use App Drawer link to help.'**
  String get downloadRdByLink;

  /// No description provided for @locDisable.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locDisable;

  /// No description provided for @locPermissionDeny.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locPermissionDeny;

  /// No description provided for @locPermanentDeny.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied.'**
  String get locPermanentDeny;

  /// No description provided for @locFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Location fetch failed:'**
  String get locFetchFailed;

  /// No description provided for @checkTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept Aadhaar consent'**
  String get checkTerms;

  /// No description provided for @viewConsent.
  ///
  /// In en, this message translates to:
  /// **'View Consent'**
  String get viewConsent;

  /// No description provided for @doitGoR.
  ///
  /// In en, this message translates to:
  /// **'© DoIT&C, Govt. of Rajasthan'**
  String get doitGoR;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aadhaarConsentEn =>
      'I (Parents/Legal Guardian, in case of minor) hereby provide my consent for the use of my Aadhaar number to perform Aadhaar based Face authentication with UIDAI for Login/Registration on DoIT&C Face Authentication mobile app. Upon successful Aadhaar based Face Authentication (Yes/No response), I provide consent to get myself registered on DoIT&C Face Authentication mobile App to use its features. I have voluntarily chosen Aadhaar based Face authentication. I also provide my explicit consent to securely store my Aadhaar number and response of Aadhaar authentication transaction.';

  @override
  String get aadhaarConsentHi =>
      'मैं (माता-पिता/कानूनी अभिभावक, यदि नाबालिग हो) स्वेच्छा से अपनी सहमति प्रदान करता/करती हूँ कि मेरे आधार संख्या का उपयोग DoIT&C फेस ऑथेंटिकेशन मोबाइल ऐप पर लॉगिन/पंजीकरण हेतु, भारतीय विशिष्ट पहचान प्राधिकरण (UIDAI) के माध्यम से आधार आधारित चेहरे के प्रमाणीकरण के लिए किया जाए। प्रमाणीकरण की प्रक्रिया में प्राप्त \"हाँ/ना\" उत्तर के आधार पर, मैं स्वयं को DoIT&C फेस ऑथेंटिकेशन मोबाइल ऐप पर पंजीकृत करने हेतु सहमति प्रदान करता/करती हूँ, जिससे ऐप की सेवाओं का उपयोग किया जा सके। मैं आधार आधारित चेहरे के प्रमाणीकरण का चयन स्वेच्छा से कर रहा/रही हूँ। साथ ही, मैं अपनी स्पष्ट सहमति देता/देती हूँ कि मेरी आधार संख्या एवं आधार प्रमाणीकरण लेन-देन की प्रतिक्रिया को सुरक्षित रूप से संग्रहीत किया जाए।';

  @override
  String get requestConsentEn =>
      'I (Parents/Legal Guardian, in case of minor) hereby provide my consent for the use of my Aadhaar number to perform Aadhaar based Face authentication on DoIT&C Face Authentication mobile app with UIDAI for <Purpose> for availing the services of <Department>. The department has informed me that my Aadhaar shall not be used for any purpose other than mentioned above. I have voluntarily chosen Aadhaar based Face authentication. I also provide my explicit consent to securely store my Aadhaar number and response of Aadhaar authentication transaction.';

  @override
  String get requestConsentHi =>
      'मैं (माता-पिता/कानूनी अभिभावक, यदि नाबालिग हो) स्वेच्छा से अपनी सहमति प्रदान करता/करती हूँ कि मेरी आधार संख्या का उपयोग DoIT&C फेस ऑथेंटिकेशन मोबाइल ऐप पर भारतीय विशिष्ट पहचान प्राधिकरण (UIDAI) के माध्यम से <Purpose> हेतु आधार आधारित चेहरे के प्रमाणीकरण के लिए किया जाए, ताकि मैं <Department> की सेवाओं का लाभ प्राप्त कर सकूँ। विभाग द्वारा मुझे सूचित किया गया है कि मेरी आधार जानकारी का उपयोग उपर्युक्त उद्देश्य के अतिरिक्त किसी अन्य कार्य हेतु नहीं किया जाएगा। मैंने स्वेच्छा से आधार आधारित चेहरे के प्रमाणीकरण का चयन किया है। इसके अतिरिक्त, मैं अपनी स्पष्ट सहमति प्रदान करता/करती हूँ कि मेरी आधार संख्या एवं प्रमाणीकरण लेन-देन की प्रतिक्रिया को सुरक्षित रूप से संग्रहीत किया जाए।';

  @override
  String get dashboardConsent =>
      'Aadhaar face authentication is based on 1:1 (exact) matching. This means that the face image captured during authentication is matched with the face image stored in the Aadhaar repository against your Aadhaar number, which was taken at the time of enrolment.';

  @override
  String get purposeTag => '<Purpose>';

  @override
  String get deptTag => '<Department>';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get appVersionTitle => 'New Version Available';

  @override
  String get threatTitle => 'Security Threat';

  @override
  String get appVersionMsg =>
      'Please download the new version of the application';

  @override
  String get notRegisterTitle => 'Welcome User';

  @override
  String get notRegisterMsg =>
      'New Registration\n\nYou are not registered. Please proceed for registration in this app.';

  @override
  String get registration => 'Registration';

  @override
  String get afa => 'Aadhaar Face Authentication';

  @override
  String get detail => 'Details';

  @override
  String get register => 'Register';

  @override
  String get update => 'Update';

  @override
  String get exit => 'Exit';

  @override
  String get reports => 'Reports';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get cancel => 'Cancel';

  @override
  String get noCancel => 'No, Cancel';

  @override
  String get yesConfirm => 'Yes, Confirm';

  @override
  String get ok => 'Ok';

  @override
  String get pendingReq => 'Pending Request';

  @override
  String get makeSureLogout => 'Are you sure you want to logout?';

  @override
  String get confirm => 'Yes, Confirm';

  @override
  String get registerAsBeneficiary => 'Register as Beneficiary';

  @override
  String get registerAsEMitra => 'Register as eMitra';

  @override
  String get aadhaarFieldValidation =>
      'Please update aadhaar number in SSO profile';

  @override
  String get nameFieldValidation => 'Please update Name SSO profile';

  @override
  String get mobileFieldValidation =>
      'Please update Mobile number in SSO profile';

  @override
  String get consentFieldValidation => 'Please Check Aadhaar consent';

  @override
  String get kioskCode => 'Kiosk Code';

  @override
  String get ssoId => 'SSO ID';

  @override
  String get enterKioskCode => 'Enter Kiosk Code';

  @override
  String get enterSsoId => 'Enter SSO ID';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter Name';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get enterMobileNumber => 'Enter Mobile No.';

  @override
  String get refAadhaarNumber => 'Ref/Aadhaar No.';

  @override
  String get registrationSuccessful => 'Registration Success';

  @override
  String get registrationSuccessMsg =>
      'Registration successful. Click OK to proceed to login.';

  @override
  String get faceRdNotFound => 'FaceRD Not Found';

  @override
  String get rdAppMissingAlert =>
      'This service requires the FaceRD app. Do you want to install it from Play Store?';

  @override
  String get userLogin => 'User Login';

  @override
  String get doITFaceAuthentication => 'DoIT&C Face Authentication';

  @override
  String get loginWithAadhaar => 'Login with Aadhaar No.';

  @override
  String get loginWithSso => 'Login with SSO ID';

  @override
  String get loginSuccessfully => 'Logged in successfully';

  @override
  String get enterAadhaarNo => 'Enter Aadhaar No.';

  @override
  String get aadhaarConsentAlert =>
      'Please check the Aadhaar consent checkbox to continue.';

  @override
  String get aadhaarNumberAlert =>
      'Please enter a valid 12-digit Aadhaar number.';

  @override
  String get tokenError => 'Invalid Token or Expired : Re Login';

  @override
  String get verify => 'Verify';

  @override
  String get aadhaar => 'Aadhaar';

  @override
  String get aadhaarNo => 'Aadhaar Number';

  @override
  String get departmentName => 'Department Name';

  @override
  String get purpose => 'Purpose';

  @override
  String get requestID => 'Request ID';

  @override
  String get referenceId => 'Reference Id';

  @override
  String get request => 'Request';

  @override
  String get requestType => 'Request Type';

  @override
  String get timeStamp => 'Time Stamp';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get errorCode => 'Error Code';

  @override
  String get noFaceAuthRequestPending => 'No Face Auth Request Pending !!';

  @override
  String get dateTime => 'Date/Time';

  @override
  String get home => 'Home';

  @override
  String get updateApp => 'Update App';

  @override
  String get downloadFaceRD => 'Download Face RD';

  @override
  String get biometricSettings => 'Biometric Lock Setting';

  @override
  String get enableBiometric => 'Enable Biometric';

  @override
  String get unlockBiometric => 'Unlock with biometric';

  @override
  String get byEnable =>
      'When enabled, biometric app lock will be activated. You can turn this feature on or off anytime';

  @override
  String get aboutUs => 'About Us';

  @override
  String get rateUs => 'Rate Us';

  @override
  String get appVersion => 'App Version';

  @override
  String get forgotPwd => 'Forgot Password?';

  @override
  String get password => 'Password';

  @override
  String get keepMeLoggedIn => 'Keep me logged in';

  @override
  String get missingSsoId => 'Please Enter SSO ID';

  @override
  String get missingPwd => 'Please Enter Password';

  @override
  String get authSuccess => 'Aadhaar Face Authentication Successful';

  @override
  String get faceRDApp => 'FaceRD App';

  @override
  String get faceAuthRDDownload =>
      'Aadhaar Face RD service app not found so download app from store';

  @override
  String get faceAuthRDAlready => 'Aadhaar Face RD App already Installed';

  @override
  String get faceAuthLocked => 'FaceAuth Locked';

  @override
  String get biometricMsg =>
      'Enable biometric login for quicker and secure access using your fingerprint or face.';

  @override
  String get aadhaarBasedAuth => 'Aadhaar Based Face Authentication';

  @override
  String get ratingMsg => 'we will work harder to make you more satisfied.';

  @override
  String get rateOnGooglePlay => 'Rate on Google Play';

  @override
  String get noThanks => 'No, Thanks!';

  @override
  String get thanks => 'Thanks!';

  @override
  String get noDataFound => 'No Data Found !!';

  @override
  String get splashMsg =>
      'Department of Information Technology\n& Communication, Government of Rajasthan';

  @override
  String get enterCaptcha => 'Enter Captcha';

  @override
  String get plzEnterValidCaptcha => 'Please enter valid Captcha';

  @override
  String get networkIssue => 'Network Issue, Try again later';

  @override
  String get deviceNotSupported => 'Device not supported';

  @override
  String get deviceNotSupportedMsg =>
      'Your device does not support biometric authentication.';

  @override
  String get authenticateToContinue => 'Authenticate to continue';

  @override
  String get authenticateFailed => 'Authentication failed';

  @override
  String get biometricErrorTag => 'Biometric error:';

  @override
  String get biometricSetupError => 'Biometrics aren\"t set up';

  @override
  String get biometricSetupErrorMsg =>
      'To enable this feature, please set up Face or Fingerprint unlock in your device settings.';

  @override
  String get aadhaarNoReport => 'Aadhaar No.';

  @override
  String get departmentNameReport => 'Department Name';

  @override
  String get dateTimeReport => 'Date/Time';

  @override
  String get requestTypeReport => 'Request Type';

  @override
  String get playHint => 'How to Login?👇';

  @override
  String get changeLang => 'Change Language';

  @override
  String get operator => 'Operator';

  @override
  String get beneficiary => 'Beneficiary';

  @override
  String get usbDebugEnabled =>
      'Detected unsafe environment due to: Device is in Usb Debugging mode.';

  @override
  String get unsafeEnvFound => 'Detected unsafe environment due to';

  @override
  String get deviceFridaRoot => 'Device Found Frida/Rooted.';

  @override
  String get deviceRooted => 'Device found rooted.';

  @override
  String get deviceEmulator => 'Device is Emulator.';

  @override
  String get mockLocEnabled => 'Device enabled mock location.';

  @override
  String get fakeLocation => 'Fake Location';

  @override
  String get downloadRdByLink =>
      'Download from play store use App Drawer link to help.';

  @override
  String get locDisable => 'Location services are disabled.';

  @override
  String get locPermissionDeny => 'Location permission denied.';

  @override
  String get locPermanentDeny => 'Location permission permanently denied.';

  @override
  String get locFetchFailed => 'Location fetch failed:';

  @override
  String get checkTerms => 'I accept Aadhaar consent';

  @override
  String get viewConsent => 'View Consent';

  @override
  String get doitGoR => '© DoIT&C, Govt. of Rajasthan';
}

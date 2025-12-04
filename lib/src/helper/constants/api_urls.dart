class ApiUrls {
  //TODO check prod base url for Prod version.
  //  static const baseURL = 'https://aadhaarauth.rajasthan.gov.in/AadhaarFaceAuthAPI/api/User/'; ///Production
  static const baseURL = 'https://aadhaarauthtest.rajasthan.gov.in/GenericFaceAuthApi/api/User/';///PreProd
  // static const baseURL = 'http://172.24.149.50:7110/api/User/'; ///Local PreProd
  // static const baseURL = 'https://103.203.136.78/GenericFaceAuthApi/api/User/';

  static final String loginVideoUrl = '/videos/LoginInstruction.mp4';
  static final String dashboardVideoUrl = '/videos/RequestVerification.mp4';

  /// E-mitra info full URL
  static const getKioskDetails = 'https://emitraapp.rajasthan.gov.in/webServicesRepository/getKioskInfoJSONBySso';

  ///working nodes with baseURL
  static const checkLoginStatus = 'CheckLoginStatus';
  static const getSsoDetails = 'GetSSODetails';
  static const ssoLogin = 'Login';
  static const ssoFaceAuthentication = 'FaceAuthentication';
  static const ssoRegister = 'Register';
  static const dashboard = 'Dashboard';
  static const faceAuthRequest = 'FaceAuthRequest';
  static const requestByStatus = 'RequestByStatus';
}

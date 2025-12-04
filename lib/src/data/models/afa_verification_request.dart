class AfaVerificationRequest {
  final String? aadhaarRefNo;
  final String? pidData;
  final String? requestId;
  final String? apiAction;
  final String? serviceId;
  final String? latitude;
  final String? longitude;
  final String? iPAddress;
  final String? mACAddress;

  AfaVerificationRequest({
    this.aadhaarRefNo,
    this.pidData,
    this.requestId,
    this.apiAction,
    this.serviceId,
    this.latitude,
    this.longitude,
    this.iPAddress,
    this.mACAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      "AadhaarRefNo": aadhaarRefNo,
      "PidData": pidData,
      "RequestId": requestId,
      "ApiAction": apiAction,
      "ServiceId": serviceId,
      "Latitude": latitude,
      "Longitude": longitude,
      "IPAddress": iPAddress,
      "MACAddress": mACAddress,
    };
  }
}
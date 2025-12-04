class AfaVerifyResponse {
  final bool isSuccess;
  final String message;
  final String? txn;
  final String? xml;
  final String? dpId;
  final String? mi;
  final String? srNo;
  final String? dc;
  final String? code;

  AfaVerifyResponse({required this.isSuccess, required this.message, this.txn,this.xml, this.dpId, this.mi, this.srNo, this.dc, this.code,});

  factory AfaVerifyResponse.fromJson(Map<String, dynamic> json) {
    return AfaVerifyResponse(
      isSuccess: json['IsSuccess'],
      message: json['Message'].toString(),
      txn: json['Txn'].toString(),
      xml: json['Xml'].toString(),
      dpId: json['DpId'].toString(),
      mi: json['Mi'].toString(),
      srNo: json['SrNo'].toString(),
      dc: json['Dc'].toString(),
      code: json['Code'].toString(),
    );
  }
}

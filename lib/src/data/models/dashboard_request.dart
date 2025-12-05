class DashboardRequest {
  final String? appCode;
  final String? data;

  DashboardRequest({
    this.appCode,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "AppCode": appCode,
      "Data": data,
    };
  }
}
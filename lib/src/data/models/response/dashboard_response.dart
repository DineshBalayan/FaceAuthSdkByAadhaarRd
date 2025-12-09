import '../../../domain/entities/dashboard_entity.dart';

class DashboardResponse {
  final bool? isSuccess;
  final String? message;
  final DashboardData? data;

  DashboardResponse({this.isSuccess, this.message, this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      isSuccess: json['IsSuccess'],
      message: json['Message'],
      data: json['Data'] != null ? DashboardData.fromJson(json['Data']) : null,
    );
  }
}

class DashboardData {
  final List<DashboardStatus>? statusList;
  final DashboardUser? user;

  DashboardData({this.statusList, this.user});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      statusList: (json['StatusList'] as List<dynamic>?)
          ?.map((e) => DashboardStatus.fromJson(e))
          .toList(),
      user: json['User'] != null ? DashboardUser.fromJson(json['User']) : null,
    );
  }
}

class DashboardStatus {
  final int? statusId;
  final String? statusName;
  final int? totalCount;

  DashboardStatus({required this.statusId, this.statusName, this.totalCount});

  factory DashboardStatus.fromJson(Map<String, dynamic> json) {
    return DashboardStatus(
      statusId: json['StatusId'],
      statusName: json['StatusName'],
      totalCount: int.tryParse(json['TotalCount'].toString()) ?? 0,
    );
  }
}

class DashboardUser {
  final String? aadhaarRefNo;
  final String? requestId;
  final String? subAuaName;
  final String? requestDate;
  final String? purpose;
  final String? requestType;
  final String? requestName;
  final String? aadhaarNo;
  final String? serviceName;
  final String? serviceStatus;

  DashboardUser({
    this.aadhaarRefNo,
    this.requestId,
    this.subAuaName,
    this.requestDate,
    this.purpose,
    this.requestType,
    this.requestName,
    this.aadhaarNo,
    this.serviceName,
    this.serviceStatus,
  });

  factory DashboardUser.fromJson(Map<String, dynamic> json) {
    return DashboardUser(
      aadhaarRefNo: json['AadhaarRefNo'].toString(),
      requestId: json['RequestId'].toString(),
      subAuaName: json['SubauaName'].toString(),
      requestDate: json['RequestDate'].toString(),
      purpose: json['Purpose'].toString(),
      requestType: json['RequestType'].toString(),
      requestName: json['RequestName'].toString(),
      aadhaarNo: json['AadhaarNo'].toString(),
      serviceName: json['ServiceName'].toString(),
      serviceStatus: json['ServiceStatus'].toString(),
    );
  }
}

extension DashboardUserMapper on DashboardUser {
  DashboardUserEntity getEntity() {
    return DashboardUserEntity(
      aadhaarRefNo: aadhaarRefNo ?? '',
      requestId: requestId ?? '',
      subAuaName: subAuaName ?? '',
      requestDate: requestDate ?? '',
      purpose: purpose ?? '',
      requestType: requestType ?? '',
      requestName: requestName ?? '',
      aadhaarNo: aadhaarNo ?? '',
      serviceName: serviceName ?? '',
      serviceStatus: serviceStatus ?? '',
    );
  }
}

extension DashboardMapper on DashboardResponse {
  DashboardEntity toEntity() {
    DashboardUser? user = data?.user;
    final statusList =
        data?.statusList?.map((e) {
          return StatusData(
            statusId: e.statusId??0,
            statusName: e.statusName ?? '',
            totalCount: e.totalCount ?? 0,
          );
        }).toList() ??
        [];

    return DashboardEntity(
      id: user?.requestId ?? '',
      message: user?.purpose ?? '',
      isApproved: true,
      statusList: statusList,
      userEntity: data?.user?.getEntity() ?? DashboardUserEntity.empty(),
    );
  }
}

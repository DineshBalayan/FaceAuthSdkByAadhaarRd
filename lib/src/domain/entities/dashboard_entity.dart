import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String id;
  final String message;
  final bool isApproved;
  final List<StatusData> statusList;
  final DashboardUserEntity userEntity;

  const DashboardEntity({
    required this.id,
    required this.message,
    required this.isApproved,
    required this.statusList,
    required this.userEntity,
  });

  @override
  List<Object?> get props => [id, message, isApproved, statusList, userEntity];
}

class StatusData extends Equatable {
  final int statusId;
  final String statusName;
  final int totalCount;

  const StatusData({
    required this.statusId,
    required this.statusName,
    required this.totalCount,
  });

  StatusData copyWith() {
    return StatusData(
      statusId: statusId,
      statusName: statusName,
      totalCount: totalCount,
    );
  }

  @override
  List<Object> get props => [statusId, statusName, totalCount,];
}

class DashboardUserEntity extends Equatable {
  final String aadhaarRefNo;
  final String requestId;
  final String subAuaName;
  final String requestDate;
  final String purpose;
  final String requestType;
  final String requestName;
  final String aadhaarNo;
  final String serviceName;
  final String serviceStatus;

  const DashboardUserEntity({
    required this.aadhaarRefNo,
    required this.requestId,
    required this.subAuaName,
    required this.requestDate,
    required this.purpose,
    required this.requestType,
    required this.requestName,
    required this.aadhaarNo,
    required this.serviceName,
    required this.serviceStatus,
  });

  factory DashboardUserEntity.empty() {
    return DashboardUserEntity(
      aadhaarRefNo: '',
      requestId: '',
      subAuaName: '',
      requestDate: '',
      purpose: '',
      requestType: '',
      requestName: '',
      aadhaarNo: '',
      serviceName: '',
      serviceStatus: '',
    );
  }

  @override
  List<Object> get props => [
    aadhaarRefNo,
    requestId,
    subAuaName,
    requestDate,
    purpose,
    requestType,
    requestName,
    aadhaarNo,
    serviceName,
    serviceStatus,
  ];
}

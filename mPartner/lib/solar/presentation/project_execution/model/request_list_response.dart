import 'package:equatable/equatable.dart';

class RequestListResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final RequestDataList data;
  final dynamic data1;

  RequestListResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory RequestListResponse.fromJson(Map<String, dynamic> json) {
    return RequestListResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: RequestDataList.fromJson(json['data']),
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'data': data.toJson(),
      'data1': data1,
    };
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class RequestDataList extends Equatable {
  final int totalListCount;
  final List<RequestlistData> dataList;


  RequestDataList({
    required this.totalListCount,
    required this.dataList,

  });

  factory RequestDataList.fromJson(Map<String, dynamic> json) {
    return RequestDataList(
        totalListCount: json['totalCount'] ?? '',
        dataList: (json['data'] as List<dynamic>)
            .map((item) => RequestlistData.fromJson(item))
            .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalListCount,
      'data':  dataList.map((item) => item.toJson()).toList(),

    };
  }

  @override
  List<Object?> get props => [
    totalListCount,
    dataList,
  ];
}


class RequestlistData extends Equatable {
  final String projectId;
  final String contactPersonName;
  final String contactPersonMobileNo;
  final String projectName;
  final String supportReason;
  final String status;

  RequestlistData({
    required this.projectId,
    required this.contactPersonName,
    required this.contactPersonMobileNo,
    required this.projectName,
    required this.supportReason,
    required this.status,
  });

  factory RequestlistData.fromJson(Map<String, dynamic> json) {
    return RequestlistData(
      projectId: json['projectId'] ?? '',
      contactPersonName: json['contactPersonName'] ?? '',
      contactPersonMobileNo: json['contactPersonMobile'] ?? '',
      projectName: json['projectName'] ?? '',
      supportReason: json['supportReason'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'contactPersonName': contactPersonName,
      'contactPersonMobileNo': contactPersonMobileNo,
      'projectName': projectName,
      'solutionType': supportReason,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
    projectId,
    contactPersonName,
    contactPersonMobileNo,
    projectName,
    supportReason,
    status,
  ];
}

import 'package:equatable/equatable.dart';

class DigitalSurveyRequestListResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<DigitalSurveyRequest> data;
  final int totalRequestCount;
  final dynamic data1;

  DigitalSurveyRequestListResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.totalRequestCount,
    this.data1,
  });

  factory DigitalSurveyRequestListResponse.fromJson(Map<String, dynamic> json) {
    final nestedData = json['data'] != null && json['data']['data'] != null
        ? json['data']['data'] as List<dynamic>
        : <dynamic>[];
    return DigitalSurveyRequestListResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: nestedData.map((item) => DigitalSurveyRequest.fromJson(item)).toList(),
      data1: json['data1'],
      totalRequestCount: json['data'] != null && json['data']['totalRequestCount'] != null
          ? json['data']['totalRequestCount']
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'data': {
        'data': data.map((item) => item.toJson()).toList(),
        'totalRequestCount': totalRequestCount,
      },
      'data1': data1,
    };
  }

  @override
  List<Object?> get props => [message, status, token, data, totalRequestCount, data1];
}

class DigitalSurveyRequest extends Equatable {
  final String projectId;
  final String contactPersonName;
  final String contactPersonMobileNo;
  final String projectName;
  final String solutionType;
  final String status;

  DigitalSurveyRequest({
    required this.projectId,
    required this.contactPersonName,
    required this.contactPersonMobileNo,
    required this.projectName,
    required this.solutionType,
    required this.status,
  });

  factory DigitalSurveyRequest.fromJson(Map<String, dynamic> json) {
    return DigitalSurveyRequest(
      projectId: json['projectId'] ?? '',
      contactPersonName: json['contactPersonName'] ?? '',
      contactPersonMobileNo: json['contactPersonMobileNo'] ?? '',
      projectName: json['projectName'] ?? '',
      solutionType: json['solutionType'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'contactPersonName': contactPersonName,
      'contactPersonMobileNo': contactPersonMobileNo,
      'projectName': projectName,
      'solutionType': solutionType,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
    projectId,
    contactPersonName,
    contactPersonMobileNo,
    projectName,
    solutionType,
    status,
  ];
}

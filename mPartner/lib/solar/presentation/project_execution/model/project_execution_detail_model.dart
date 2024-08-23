import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../utils/solar_app_constants.dart';

class ProjectExecutionRequestDetailResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<ProjectExecutionRequestDetail> data;
  final dynamic data1;

  ProjectExecutionRequestDetailResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory ProjectExecutionRequestDetailResponse.fromJson(
      Map<String, dynamic> json) {
    return ProjectExecutionRequestDetailResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => ProjectExecutionRequestDetail.fromJson(item))
          .toList(),
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'data': data.map((item) => item.toJson()).toList(),
      'data1': data1,
    };
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class ProjectExecutionRequestDetail extends Equatable {
  final String? projectExecutionType;
  final String? projectId;
  final String? projectType;
  final String? companyName;
  final String? contactPersonName;
  final String? contactPersonMobileNo;
  final String? contactPersonEmailId;
  final String? secondaryContactName;
  final String? secondaryContactMobileNo;
  final String? secondaryContactEmailId;
  final String? projectName;
  final String? projectAddress;
  final String? projectLandmark;
  final String? projectCurrentLocation;
  final String? pincode;
  final String? city;
  final String? state;
  final String? solutionType;
  final String? supportReason;
  final String? subCategory;
  final String? status;
  final String? remark;
  final String? reason;
  final String? preferredDate;
  final String? documentPath;
  final String? requestDate;
  final String? lastUpdateDate;
  final String? assignedISP;
  final List<DigitalRequestDesignIntegration> designIntegrations;

  const ProjectExecutionRequestDetail({
    required this.projectExecutionType,
    required this.projectId,
    required this.projectType,
    required this.companyName,
    required this.contactPersonName,
    required this.contactPersonMobileNo,
    required this.contactPersonEmailId,
    required this.secondaryContactName,
    required this.secondaryContactMobileNo,
    required this.secondaryContactEmailId,
    required this.projectName,
    required this.projectAddress,
    required this.projectLandmark,
    required this.projectCurrentLocation,
    required this.pincode,
    required this.city,
    required this.state,
    required this.solutionType,
    required this.supportReason,
    required this.subCategory,
    required this.status,
    required this.remark,
    required this.reason,
    required this.preferredDate,
    required this.documentPath,
    required this.requestDate,
    required this.lastUpdateDate,
    required this.assignedISP,
    required this.designIntegrations,
  });

  factory ProjectExecutionRequestDetail.fromJson(Map<String, dynamic> json) {
    return ProjectExecutionRequestDetail(
      projectExecutionType: json['projectExecutionType'] ?? "-",
      projectId: json['projectId'] ?? "-",
      projectType: json['projectType'] ?? "-",
      companyName: json['companyName'] ?? "-",
      contactPersonName: json['contactPersonName'] ?? "-",
      contactPersonMobileNo: json['contactPersonMobileNo'] ?? "-",
      contactPersonEmailId: json['contactPersonEmailId'] ?? "-",
      secondaryContactName: json['secondaryContactName'] ?? "-",
      secondaryContactMobileNo: json['secondaryContactMobileNo'] ?? "-",
      secondaryContactEmailId: json['secondaryContactEmailId'] ?? "-",
      projectName: json['projectName'] ?? "-",
      projectAddress: json['projectAddress'] ?? "-",
      projectLandmark: json['projectLandmark'] ?? "-",
      projectCurrentLocation: json['projectCurrentLocation'] ?? "-",
      pincode: json['pincode'] ?? "-",
      city: json['city'] ?? "-",
      state: json['state'] ?? "-",
      solutionType: json['solutionType'] ?? "-",
      supportReason: json['supportReason'] ?? "-",
      subCategory: json['subCategory'] ?? "-",
      status: json['status'] ?? "-",
      remark: json['remark'] ?? "-",
      reason: json['reason'] ?? "-",
      preferredDate: json['preferredDate'] ?? "-",
      documentPath: json['documentPath'] ?? "-",
      assignedISP: json['assignedISP'] ?? "-",
      requestDate: (json['requestDate'] == null)
          ? "-"
          : DateFormat(SolarAppConstants.dateTimeFormatCalender)
              .format(DateTime.parse(json['requestDate'])),
      lastUpdateDate: (json['lastUpdateDate'] == null)
          ? "-"
          : DateFormat(SolarAppConstants.dateTimeFormatCalender)
              .format(DateTime.parse(json['lastUpdateDate'])),
      designIntegrations: (json['executionIterations'] == null)
          ? []
          : (json['executionIterations'] as List<dynamic>)
              .map((item) => DigitalRequestDesignIntegration.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectExecutionType': projectExecutionType,
      'projectId': projectId,
      'projectType': projectType,
      'companyName': companyName,
      'contactPersonName': contactPersonName,
      'contactPersonMobileNo': contactPersonMobileNo,
      'contactPersonEmailId': contactPersonEmailId,
      'secondaryContactName': secondaryContactName,
      'secondaryContactMobileNo': secondaryContactMobileNo,
      'secondaryContactEmailId': secondaryContactEmailId,
      'projectName': projectName,
      'projectAddress': projectAddress,
      'projectLandmark': projectLandmark,
      'projectCurrentLocation': projectCurrentLocation,
      'pincode': pincode,
      'city': city,
      'state': state,
      'solutionType': solutionType,
      'supportReason': supportReason,
      'subCategory': subCategory,
      'status': status,
      'remark': remark,
      'reason': reason,
      'preferredDate': preferredDate,
      'documentPath': documentPath,
      'requestDate': requestDate,
      'lastUpdateDate': lastUpdateDate,
      'assignedISP': assignedISP,
      'designIntegrations':
          designIntegrations.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        projectExecutionType,
        projectId,
        projectType,
        companyName,
        contactPersonName,
        contactPersonMobileNo,
        contactPersonEmailId,
        secondaryContactName,
        secondaryContactMobileNo,
        secondaryContactEmailId,
        projectName,
        projectAddress,
        projectLandmark,
        projectCurrentLocation,
        pincode,
        city,
        state,
        solutionType,
        supportReason,
        subCategory,
        status,
        remark,
        reason,
        preferredDate,
        documentPath,
        designIntegrations,
      ];
}

class DigitalRequestDesignIntegration extends Equatable {
  final int designIntegration;
  final String? threeDModelLink;
  final String? solarDesignPDF;
  final String? remark;

  DigitalRequestDesignIntegration({
    required this.designIntegration,
    this.threeDModelLink,
    this.solarDesignPDF,
    this.remark,
  });

  factory DigitalRequestDesignIntegration.fromJson(Map<String, dynamic> json) {
    return DigitalRequestDesignIntegration(
      designIntegration: json['designItegration'] ?? 0,
      threeDModelLink: json['threeDModelLink'],
      solarDesignPDF: json['solarDesignPDF'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'designItegration': designIntegration,
      'threeDModelLink': threeDModelLink,
      'solarDesignPDF': solarDesignPDF,
      'remark': remark,
    };
  }

  @override
  List<Object?> get props =>
      [designIntegration, threeDModelLink, solarDesignPDF, remark];
}

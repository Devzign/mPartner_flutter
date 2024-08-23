import 'package:equatable/equatable.dart';

class DigitalRequestByProjectIdResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<DigitalRequestData> data;
  final dynamic data1;

  DigitalRequestByProjectIdResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory DigitalRequestByProjectIdResponse.fromJson(Map<String, dynamic> json) {
    return DigitalRequestByProjectIdResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => DigitalRequestData.fromJson(item))
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

class DigitalRequestData extends Equatable {
  final int? leadId;
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
  final int? avgEnergyConsumption;
  final int? avgMonthlyBill;
  final String? status;
  final String? remark;
  final String? reason;
  final String? billImagePath;
  final String? preferredDateOfVisit;
  final String? solarModuleType;
  final bool? enableIteration;
  final String? requestDate;
  final String? lastUpdateDate;
  final String? assignedISP;
  final List<DigitalRequestDesignIntegration> designIntegrations;

  DigitalRequestData({
    required this.leadId,
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
    required this.avgEnergyConsumption,
    required this.avgMonthlyBill,
    required this.status,
    required this.remark,
    required this.reason,
    required this.billImagePath,
    required this.preferredDateOfVisit,
    required this.solarModuleType,
    required this.enableIteration,
    required this.requestDate,
    required this.lastUpdateDate,
    required this.assignedISP,
    required this.designIntegrations,
  });

  factory DigitalRequestData.fromJson(Map<String, dynamic> json) {
    return DigitalRequestData(
      leadId: json['leadId'],
      projectId: json['projectId'],
      projectType: json['projectType'],
      companyName: json['companyName'],
      contactPersonName: json['contactPersonName'],
      contactPersonMobileNo: json['contactPersonMobileNo'],
      contactPersonEmailId: json['contactPersonEmailId'],
      projectName: json['projectName'],
      projectAddress: json['projectAddress'],
      projectLandmark: json['projectLandmark'],
      secondaryContactName: json['secondaryContactName'],
      secondaryContactMobileNo: json['secondaryContactMobileNo'],
      secondaryContactEmailId: json['secondaryContactEmailId'],
      projectCurrentLocation: json['projectCurrentLocation'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      solutionType: json['solutionType'],
      avgEnergyConsumption: json['avgEnergyConsumption'],
      avgMonthlyBill: json['avgMonthlyBill'],
      status: json['status'],
      remark: json['remark'],
      reason: json['reason'],
      billImagePath: json['billImagePath'],
      preferredDateOfVisit: json['preferredDateOfVisit'],
      solarModuleType: json['solarModuleType'],
      enableIteration: json['enableIteration'],
      requestDate: json['requestDate'],
      lastUpdateDate: json['lastUpdateDate'],
      assignedISP: json['assignedISP'],
      designIntegrations: (json['designItegrations'] as List<dynamic>)
          .map((item) => DigitalRequestDesignIntegration.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leadId': leadId,
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
      'avgEnergyConsumption': avgEnergyConsumption,
      'avgMonthlyBill': avgMonthlyBill,
      'status': status,
      'remark': remark,
      'reason': reason,
      'billImagePath': billImagePath,
      'preferredDateOfVisit': preferredDateOfVisit,
      'solarModuleType': solarModuleType,
      'enableIteration': enableIteration,
      'requestDate': requestDate,
      'lastUpdateDate': lastUpdateDate,
      'assignedISP': assignedISP,
      'designIntegrations': designIntegrations.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    leadId,
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
    avgEnergyConsumption,
    avgMonthlyBill,
    status,
    remark,
    reason,
    billImagePath,
    preferredDateOfVisit,
    solarModuleType,
    enableIteration,
    requestDate,
    lastUpdateDate,
    assignedISP,
    designIntegrations,
  ];
}

class DigitalRequestDesignIntegration extends Equatable {
  final int designIntegration;
  final String? threeDModelLink;
  final String? solarDesignPDF;

  DigitalRequestDesignIntegration({
    required this.designIntegration,
    this.threeDModelLink,
    this.solarDesignPDF,
  });

  factory DigitalRequestDesignIntegration.fromJson(Map<String, dynamic> json) {
    return DigitalRequestDesignIntegration(
      designIntegration: json['designItegration'] ?? 0,
      threeDModelLink: json['threeDModelLink'],
      solarDesignPDF: json['solarDesignPDF'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'designItegration': designIntegration,
      'threeDModelLink': threeDModelLink,
      'solarDesignPDF': solarDesignPDF,
    };
  }

  @override
  List<Object?> get props => [designIntegration, threeDModelLink, solarDesignPDF];
}
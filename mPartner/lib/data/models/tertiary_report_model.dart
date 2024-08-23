import 'dart:convert';

class TertiaryReport {
  String message;
  String status;
  String token;
  List<TertiaryReportListData> data;
  String data1;

  TertiaryReport({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  List<Object?> get props => [message, status, token, data, data1];

  factory TertiaryReport.fromJson(Map<String, dynamic> json) => TertiaryReport(
        message: json["message"] ?? "",
        status: json["status"] ?? "",
        token: json["token"] ?? "",
        data: List<TertiaryReportListData>.from(
                json["data"].map((x) => TertiaryReportListData.fromJson(x))) ??
            [],
        data1: json["data1"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "message": message ?? "",
        "status": status ?? "",
        "token": token ?? "",
        "data": List<dynamic>.from(data.map((x) => x.toJson())) ?? [],
        "data1": data1 ?? "",
      };
}

class TertiaryReportListData {
  String customerName;
  String customerPhone;
  String customerAddress;
  String productSerialNumber;
  String systemStatus;
  String systemRemark;
  String primaryDate;
  String tertiaryDate;
  String secondarySaleDate;
  String productType;
  String productModel;

  TertiaryReportListData({
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.primaryDate,
    required this.productSerialNumber,
    required this.productType,
    required this.secondarySaleDate,
    required this.systemRemark,
    required this.systemStatus,
    required this.tertiaryDate,
    required this.productModel
  });

  List<Object?> get props => [
        customerName,
        customerPhone,
        customerAddress,
        productSerialNumber,
        systemStatus,
        systemRemark,
        primaryDate,
        tertiaryDate,
        secondarySaleDate,
        productType,
        productModel
      ];

  factory TertiaryReportListData.fromJson(Map<String, dynamic> json) =>
      TertiaryReportListData(
        customerName: json["customer_Name"] ?? "",
        customerPhone: json["customer_Phone"] ?? "",
        customerAddress: json["customer_Address"] ?? "",
        productSerialNumber: json["product_Serial_Number"] ?? "",
        systemStatus: json["systemStatus"] ?? "",
        systemRemark: json["systemRemark"] ?? "",
        primaryDate: json["primary_Date"] ?? "",
        tertiaryDate: json["tertiaryDate"] ?? "",
        secondarySaleDate: json['secondarySaleDate'] ?? "",
        productType: json['product_type'] ?? "",
        productModel: json['product_Model'] ?? ""
      );

  Map<String, dynamic> toJson() => {
        "customer_Name": customerName,
        "customer_Phone": customerPhone,
        "customer_Address": customerAddress,
        "product_Serial_Number": productSerialNumber,
        "product_Model": productModel,
        "systemStatus": systemStatus,
        "systemRemark": systemRemark,
        "primary_Date" : primaryDate,
        "tertiaryDate" : tertiaryDate,
        "secondarySaleDate": secondarySaleDate,
        "product_type": productType,
      };
}

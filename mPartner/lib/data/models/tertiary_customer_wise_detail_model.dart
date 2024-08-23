import 'dart:convert';

class TertiaryCustomerWiseDetails {
  String message;
  String status;
  String token;
  List<TertiaryCustomerDetails> data;
  String data1;

  TertiaryCustomerWiseDetails({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  List<Object?> get props => [message, status, token, data, data1];

  factory TertiaryCustomerWiseDetails.fromJson(Map<String, dynamic> json) {
    return TertiaryCustomerWiseDetails(
      message: json["message"] ?? "",
      status: json["status"] ?? "",
      token: json["token"] ?? "",
      data: _parseData(json["data"]),
      data1: json["data1"] ?? "",
    );
  }

  static List<TertiaryCustomerDetails> _parseData(dynamic data) {
    if (data is List) {
      return List<TertiaryCustomerDetails>.from(
              data.map((x) => TertiaryCustomerDetails.fromJson(x))) ??
          [];
    } else {
      return [];
    }
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "token": token,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "data1": data1,
      };
}

class TertiaryCustomerDetails {
  String productModel;
  String productSerialNumber;
  String systemStatus;
  String systemRemark;
  String primaryDate;
  String secondaryDate;
  String tertiaryDate;

  TertiaryCustomerDetails({
    required this.productModel,
    required this.productSerialNumber,
    required this.systemStatus,
    required this.systemRemark,
    required this.primaryDate,
    required this.secondaryDate,
    required this.tertiaryDate,
  });

  List<Object?> get props => [
        productModel,
        productSerialNumber,
        systemStatus,
        systemRemark,
        primaryDate,
        secondaryDate,
        tertiaryDate,
      ];

  factory TertiaryCustomerDetails.fromJson(Map<String, dynamic> json) =>
      TertiaryCustomerDetails(
        productModel: json["product_Model"] ?? "",
        productSerialNumber: json["product_Serial_Number"] ?? "",
        systemStatus: json["systemStatus"] ?? "",
        systemRemark: json["systemRemark"] ?? "N/A",
        primaryDate: json["primary_Date"] ?? "N/A",
        secondaryDate: json["secondaryDate"] ?? "N/A",
        tertiaryDate: json["tertiaryDate"] ?? "N/A",
      );

  Map<String, dynamic> toJson() => {
        "product_Model": productModel,
        "product_Serial_Number": productSerialNumber,
        "systemStatus": systemStatus,
        "systemRemark": systemRemark,
        "primary_Date": primaryDate,
        "secondaryDate": secondaryDate,
        "tertiaryDate": tertiaryDate,
      };
}

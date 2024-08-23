import 'package:equatable/equatable.dart';

class TransactionDetailsResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<TransactionData> data;
  final dynamic data1;

  const TransactionDetailsResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory TransactionDetailsResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json["data"] as List;
    List<TransactionData> parsedDataList =
        dataList.map((data) => TransactionData.fromJson(data)).toList();

    return TransactionDetailsResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: parsedDataList,
      data1: json["data1"],
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class TransactionData extends Equatable {
  String status;
  String redeemed;
  String totalAmount;
  String transactionId;
  String message;
  String transactionDate;
  String totalCoins;
  String otpRemark;
  String serialNumber;
  String productType;
  String modelName;
  String customerName;
  String customerPhone;
  String saleRemark;
  String redemptionMode;
  String transMsg;
  String remark;

  TransactionData({
    required this.status,
    required this.redeemed,
    required this.totalAmount,
    required this.transactionId,
    required this.message,
    required this.transactionDate,
    required this.totalCoins,
    required this.otpRemark,
    required this.serialNumber,
    required this.productType,
    required this.modelName,
    required this.customerName,
    required this.customerPhone,
    required this.saleRemark,
    required this.redemptionMode,
    required this.transMsg,
    required this.remark,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
        status: json["status"] ?? "",
        redeemed: json["redeemed"] ?? "",
        totalAmount: json["totalAmount"] ?? "",
        transactionId: json["transactionId"],
        message: json["message"] ?? "",
        transactionDate: json["transactionDate"] ?? "",
        totalCoins: json["totalCoins"] ?? "",
        otpRemark: json["otpRemark"] ?? "",
        serialNumber: json["serialNumber"] ?? "",
        productType: json["productType"] ?? "",
        modelName: json["modelName"] ?? "",
        customerName: json["customerName"] ?? "",
        customerPhone: json["customerPhone"] ?? "",
        saleRemark: json["saleRemark"] ?? "",
        transMsg: json["transMsg"] ?? "",
        redemptionMode: json["redemptionMode"] ?? "",
        remark: json["remark"] ?? "");
  }

  @override
  List<Object?> get props => [
        status,
        redeemed,
        totalAmount,
        transactionId,
        message,
        transactionDate,
        totalCoins,
        otpRemark,
        serialNumber,
        productType,
        modelName,
        customerName,
        customerPhone,
        customerPhone,
        saleRemark,
        redemptionMode,
        transMsg,
        remark
      ];
}

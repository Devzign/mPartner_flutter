import 'package:equatable/equatable.dart';

class EW_SaveWithOTPResponse {
  final String message;
  final String status;
  final String token;
  final List<EW_SaveWithOTPData> data;
  final dynamic data1; // It seems data1 can be of various types, so use dynamic

  EW_SaveWithOTPResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory EW_SaveWithOTPResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json["data"] as List;
    List<EW_SaveWithOTPData> parsedDataList =
        dataList.map((data) => EW_SaveWithOTPData.fromJson(data)).toList();

    return EW_SaveWithOTPResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: parsedDataList,
      data1: json["data1"],
    );
  }
}

class EW_SaveWithOTPData extends Equatable {
  final String? code;
  final String? des;
  final String? serialNo;
  final String? wrsPoint;
  final String? tripPoint;
  final String? coin_Points;
  final String? status;
  final String? otpRemark;
  final String? productType;
  final String? model;
  final String? registeredOn;
  final String? msgType;

  EW_SaveWithOTPData({
    required this.code,
    required this.des,
    required this.serialNo,
    required this.wrsPoint,
    required this.tripPoint,
    required this.coin_Points,
    required this.status,
    required this.otpRemark,
    required this.productType,
    required this.model,
    required this.registeredOn,
    required this.msgType,
  });

  factory EW_SaveWithOTPData.fromJson(Map<String, dynamic> json) {
    return EW_SaveWithOTPData(
      code: json["code"],
      des: json["des"],
      serialNo: json["serialNo"],
      wrsPoint: json["wrsPoint"],
      tripPoint: json["tripPoint"],
      coin_Points: json["coin_Points"],
      status: json["status"],
      otpRemark: json["otpRemark"],
      productType: json["productType"],
      model: json["model"],
      registeredOn: json["registeredOn"],
      msgType: json["msgType"],
    );
  }

  @override
  List<Object?> get props => [
        code,
        des,
        serialNo,
        wrsPoint,
        tripPoint,
        coin_Points,
        status,
        otpRemark,
        productType,
        model,
        registeredOn,
        msgType
      ];
}

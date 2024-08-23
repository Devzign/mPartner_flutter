import 'package:equatable/equatable.dart';

class EWVerifyOtpResponse {
  final String message;
  final String status;
  final String token;
  final EWVerifyOtpData data;
  final String data1;

  EWVerifyOtpResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory EWVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return EWVerifyOtpResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: EWVerifyOtpData.fromJson(json["data"]),
      data1: json["data1"],
    );
  }
}

class EWVerifyOtpData {
  final String code;
  final String des;

  EWVerifyOtpData({
    required this.code,
    required this.des,
  });

  factory EWVerifyOtpData.fromJson(Map<String, dynamic> json) {
    return EWVerifyOtpData(
      code: json["code"],
      des: json["des"],
    );
  }
}

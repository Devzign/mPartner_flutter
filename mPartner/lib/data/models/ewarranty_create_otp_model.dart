import 'package:equatable/equatable.dart';

class EWCreateOtp {
  final String message;
  final String status;
  final String token;
  final EWCreateOtpData data;
  final String data1;

  EWCreateOtp({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory EWCreateOtp.fromJson(Map<String, dynamic> json) {
    return EWCreateOtp(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: EWCreateOtpData.fromJson(json["data"]),
      data1: json["data1"],
    );
  }
}

class EWCreateOtpData {
  final String code;
  final String des;
  final String transID;

  EWCreateOtpData({
    required this.code,
    required this.des,
    required this.transID,
  });

  factory EWCreateOtpData.fromJson(Map<String, dynamic> json) {
    return EWCreateOtpData(
      code: json["code"],
      des: json["des"],
      transID: json["transID"],
    );
  }
}

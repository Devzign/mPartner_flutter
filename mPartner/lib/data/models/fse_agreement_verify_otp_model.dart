import 'package:equatable/equatable.dart';

class FseAgreementVerifyOtpResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final List<DataItem> data;
  final dynamic data1;

  const FseAgreementVerifyOtpResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory FseAgreementVerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return FseAgreementVerifyOtpResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: List<DataItem>.from(json["data"].map((x) => DataItem.fromJson(x))),
      data1: json["data1"],
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}

class DataItem {
  final String code;
  final String desc;

  DataItem({
    required this.code,
    required this.desc,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      code: json["code"],
      desc: json["desc"],
    );
  }
}
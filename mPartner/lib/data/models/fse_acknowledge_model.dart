import 'package:equatable/equatable.dart';

class FseAcknowledgeResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final dynamic data;
  final dynamic data1;

  const FseAcknowledgeResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory FseAcknowledgeResponse.fromJson(Map<String, dynamic> json) {
    return FseAcknowledgeResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: json["data"],
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
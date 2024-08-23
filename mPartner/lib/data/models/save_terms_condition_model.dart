import 'package:equatable/equatable.dart';

class SaveTermsConditionResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final dynamic data;
  final dynamic data1;

  SaveTermsConditionResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory SaveTermsConditionResponse.fromJson(
      Map<String, dynamic> json) {
    return SaveTermsConditionResponse(
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


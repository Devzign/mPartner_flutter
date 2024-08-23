import 'package:equatable/equatable.dart';

class ReadNotificationDetailOnIdResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final dynamic data;
  final dynamic data1;

  ReadNotificationDetailOnIdResponse({
    required this.message,
    required this.status,
    required this.token,
    this.data,
    this.data1,
  });

  factory ReadNotificationDetailOnIdResponse.fromJson(Map<String, dynamic> json) {
    return ReadNotificationDetailOnIdResponse(
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

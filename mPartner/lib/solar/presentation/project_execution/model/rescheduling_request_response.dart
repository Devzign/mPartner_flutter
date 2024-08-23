import 'package:equatable/equatable.dart';

class ReScheduleRequestResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final dynamic data;
  final dynamic data1;

  ReScheduleRequestResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory ReScheduleRequestResponse.fromJson(Map<String, dynamic> json) {
    return ReScheduleRequestResponse(
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


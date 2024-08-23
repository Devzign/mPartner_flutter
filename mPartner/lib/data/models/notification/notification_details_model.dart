import 'package:equatable/equatable.dart';

import 'notification_list_model.dart';

class NotificationDetailResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final NotificationData data;
  final dynamic data1;

  const NotificationDetailResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {

    return NotificationDetailResponse(
      message: json["message"],
      status: json["status"],
      token: json["token"],
      data: NotificationData.fromJson(json["data"]),
      data1: json["data1"],
    );
  }

  @override
  List<Object?> get props => [message, status, token, data, data1];
}



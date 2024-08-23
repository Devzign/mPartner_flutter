import 'package:equatable/equatable.dart';

class FeedBackAnswersResponse {
  String message;
  String status;
  String token;
  dynamic data;
  dynamic data1;

  FeedBackAnswersResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory FeedBackAnswersResponse.fromJson(Map<String, dynamic> json) {
    return FeedBackAnswersResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] ?? '',
      data: json['data'],
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'token': token,
      'data': data,
      'data1': data1,
    };
  }
}


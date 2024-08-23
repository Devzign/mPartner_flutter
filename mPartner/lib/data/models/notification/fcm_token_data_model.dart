import 'package:equatable/equatable.dart';

class FcmTokenResponse extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const FcmTokenResponse(
      {required this.message,
      required this.status,
      required this.token,
      required this.data,
      required this.data1});

  @override
  List<Object> get props => [message, status, token, data, data1];

  factory FcmTokenResponse.fromJson(Map<String, dynamic> json) =>
      FcmTokenResponse(
          status: json["status"] ?? '',
          token: json["token"] ?? '',
          message: json["message"] ?? '',
          data: json['data'] ?? '',
          data1: json['data1'] ?? '');
}

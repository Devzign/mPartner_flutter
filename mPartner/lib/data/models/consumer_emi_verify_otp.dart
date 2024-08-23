import 'package:equatable/equatable.dart';

class ConsumerEmiVerifyOTP extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const ConsumerEmiVerifyOTP({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory ConsumerEmiVerifyOTP.fromJson(Map<String, dynamic> json) {
    return ConsumerEmiVerifyOTP(
      message: json['message'],
      status: json['status'],
      token: json['token'],
      data: json['data'] as String? ?? '',
      data1: json['data1'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [
    message,
    status,
    token,
    data,
    data1
  ];
}
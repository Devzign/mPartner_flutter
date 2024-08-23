import 'package:equatable/equatable.dart';

class VerifyOTP extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const VerifyOTP({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  factory VerifyOTP.fromJson(Map<String, dynamic> json) {
    return VerifyOTP(
      message: json['message'],
      status: json['status'],
      token: json['token'] as String? ?? '',
      data: json['data'] as String? ?? '',
      data1: json['data1'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [message, status, token, data, data1];
}

class VerifyOtpParameters extends Equatable {
  final String getId;
  final String getOTP;

  const VerifyOtpParameters({required this.getId, required this.getOTP});
  @override
  List<Object> get props => [getId, getOTP];
}

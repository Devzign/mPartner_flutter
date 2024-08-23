import 'package:equatable/equatable.dart';

class PinelabSendOTP extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const PinelabSendOTP({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  @override
  List<Object> get props => [
    message,
    status,
    token,
    data,
    data1
  ];
}
class PinelabOTPResponse extends PinelabSendOTP {

  const PinelabOTPResponse({required super.message, required super.status, required super.token, required super.data, required super.data1});

  factory PinelabOTPResponse.fromJson(Map<String, dynamic> json) {
    return PinelabOTPResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'] as String? ?? '',
      data: json['data'] as String? ?? '',
      data1: json['data1'] as String? ?? '',
    );
  }
}



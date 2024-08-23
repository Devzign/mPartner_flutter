import 'package:equatable/equatable.dart';

class ConsumerEmiSendOTP extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const ConsumerEmiSendOTP({
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
class ConsumerEmiOTPResponse extends ConsumerEmiSendOTP {

  const ConsumerEmiOTPResponse({required super.message, required super.status, required super.token, required super.data, required super.data1});

  factory ConsumerEmiOTPResponse.fromJson(Map<String, dynamic> json) {
    return ConsumerEmiOTPResponse(
      message: json['message'],
      status: json['status'],
      token: json['token'] as String? ?? '',
      data: json['data'] as String? ?? '',
      data1: json['data1'] as String? ?? '',
    );
  }
}

class GetOtpParameters extends Equatable {
  final String phoneNumber;

  const GetOtpParameters({required this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
}


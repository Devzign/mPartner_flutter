import 'package:equatable/equatable.dart';

class SendOTP extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const SendOTP({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  @override
  List<Object> get props => [message, status, token, data, data1];
}

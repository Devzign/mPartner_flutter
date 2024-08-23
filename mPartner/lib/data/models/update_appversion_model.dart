import 'package:equatable/equatable.dart';

class UpdateAppVersionModel extends Equatable {
  final String message;
  final String status;
  final String token;
  final String data;
  final String data1;

  const UpdateAppVersionModel({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    required this.data1,
  });

  @override
  List<Object> get props => [
    message, status, token, data, data1
  ];

  factory UpdateAppVersionModel.fromJson(Map<String, dynamic> json) => UpdateAppVersionModel(
    message: json['message'],
    status: json['status'],
    token: json['token'],
    data: json['data'] as String? ?? '',
    data1: json['data1'] as String? ?? '',
  );
}

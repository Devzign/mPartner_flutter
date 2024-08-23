import 'package:equatable/equatable.dart';

class CreateOTPResponse extends Equatable {
  final String message;
  final String status;
  final String? token;
  final OtpData data;
  final String? data1;

  const CreateOTPResponse({
    required this.message,
    required this.status,
    required this.token,
    required this.data,
    this.data1,
  });

  factory CreateOTPResponse.fromJson(Map<String, dynamic> json) {
    return CreateOTPResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      token: json['token'] as String? ?? '',
      data: OtpData.fromJson(json['data'] as Map<String, dynamic>) ?? OtpData.empty(),
      data1: json['data1'] as String? ?? '',
    );
  }

  @override
  List<Object> get props => [
    message,
    status,
    data
  ];
}

class OtpData extends Equatable {
  final String code;
  final String des;
  final String transId;

  const OtpData({
    required this.code,
    required this.des,
    required this.transId,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      code: json['code']??'',
      des: json['des']??'',
      transId: json['transID']??'',
    );
  }

  static OtpData empty(){
    return const OtpData(code: '', des: '', transId: '');
  }

  @override
  List<Object> get props => [code,des,transId];
}

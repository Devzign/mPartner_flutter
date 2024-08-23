import 'package:equatable/equatable.dart';
import 'package:mpartner/data/models/send_otp.dart';

// class OTPResponseModel extends SendOTP {
//
//   const OTPResponseModel({required super.message, required super.status, required super.disid});
//
//   factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
//     return OTPResponseModel(
//       message: json['Message'],
//       status: json['Status'],
//       disid: json['Disid'],
//     );
//   }
// }
class OTPResponse extends SendOTP {
  const OTPResponse(
      {required super.message,
      required super.status,
      required super.token,
      required super.data,
      required super.data1});

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
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

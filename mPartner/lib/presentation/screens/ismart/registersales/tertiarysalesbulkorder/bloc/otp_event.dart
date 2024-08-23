part of 'otp_bloc.dart';

@immutable
abstract class OTPEvent extends Equatable{
  final CustomerInfo customerInfo;
  final String serialNo;


  const OTPEvent({
    required this.customerInfo,
    required this.serialNo
  });

  @override
  List<Object> get props => [customerInfo,serialNo];
}

class CreateOTPEvent extends OTPEvent{
  CreateOTPEvent({
    required super.customerInfo,
    required super.serialNo
  });
}

class VerifyOTPEvent extends OTPEvent {
  final String otp;
  final String transId;

  const VerifyOTPEvent({
    required CustomerInfo customerInfo,
    required String serialNo,
    required this.otp,
    required this.transId,
  }) : super(customerInfo: customerInfo, serialNo: serialNo);

}

class ResendOTPEvent extends OTPEvent {
  const ResendOTPEvent({
    required CustomerInfo customerInfo,
    required String serialNo,
  }) : super(customerInfo: customerInfo, serialNo: serialNo);
}


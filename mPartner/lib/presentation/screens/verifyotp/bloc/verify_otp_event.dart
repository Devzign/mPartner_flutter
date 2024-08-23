part of 'verify_otp_bloc.dart';

@immutable
abstract class VerifyOtpEvent extends Equatable{
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitialActionEvent extends VerifyOtpEvent{
  final String getId;
  final String getOtp;
  final String phoneNo;
  const VerifyOtpInitialActionEvent(this.getId, this.getOtp, this.phoneNo);
}

class VerifyOtpResendActionEvent extends VerifyOtpEvent{
  final String getId;
  final String phoneNo;
  const VerifyOtpResendActionEvent(this.getId, this.phoneNo);
}

class SAPIDSelectionActionEvent extends VerifyOtpEvent{
  final int userDataIndex ;
  final String getOtp;
  const SAPIDSelectionActionEvent(this.userDataIndex, this.getOtp);
}
class GetProfileInfoEvent extends VerifyOtpEvent{
  const GetProfileInfoEvent();
}

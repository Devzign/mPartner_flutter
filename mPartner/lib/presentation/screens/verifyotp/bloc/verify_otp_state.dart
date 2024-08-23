part of 'verify_otp_bloc.dart';

@immutable
abstract class VerifyOtpState {}

abstract class VerifyActionState extends VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState{}

class VerifyOtpErrorState extends VerifyActionState {
  final String message;
  VerifyOtpErrorState(this.message);
}

class VerifyOtpResendState extends VerifyActionState {
  final String maxAttemptMsg;
  VerifyOtpResendState(this.maxAttemptMsg);
}

class OtpSuccessResendState extends VerifyActionState {
  final String timerMaxData;
  OtpSuccessResendState(this.timerMaxData);
}

class NavigateToVerifyOtpActionState extends VerifyActionState{
  final List<UserData> splashScreenData;
  final String otpVerifiedMsg;
  NavigateToVerifyOtpActionState(this.splashScreenData, this.otpVerifiedMsg);
}

class NavigateToVerifyOtpSuccessActionState extends VerifyActionState{}
class NavigateToDummyScreenSuccessActionState extends VerifyActionState{}
class LoginShowLoader extends VerifyActionState{
  final bool showLoader;

  LoginShowLoader(this.showLoader);
}
class ShowIncorrectOtpMaxLimitAlertState extends VerifyActionState{
  final String maxAttemptMsg;
  ShowIncorrectOtpMaxLimitAlertState(this.maxAttemptMsg);
}
class ShowLoginFailedAlertState extends VerifyActionState{
  final String alertMessage;
  ShowLoginFailedAlertState(this.alertMessage);
}



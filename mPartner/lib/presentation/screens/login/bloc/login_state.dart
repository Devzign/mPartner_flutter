part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class SendOtpButtonClickGetUserData extends LoginActionState{}

class NavigateToFillingOtpActionState extends LoginActionState{
  final String id;
  final String message;
  final String timerData;

  NavigateToFillingOtpActionState(this.id, this.message, this.timerData);
}

class LoginMaxAttemptState extends LoginActionState{
  final String maxAttemptMsg;

  LoginMaxAttemptState(this.maxAttemptMsg);
}

class LoginUnregisterNotState extends LoginActionState{
  final String unRegisterNoMsg;

  LoginUnregisterNotState(this.unRegisterNoMsg);
}

class LoginShowLoader extends LoginActionState{
  final bool showLoader;

  LoginShowLoader(this.showLoader);
}

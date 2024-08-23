part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable{
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInitialActionEvent extends LoginEvent{
  final String number;
  const LoginInitialActionEvent(this.number);
}

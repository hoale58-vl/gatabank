import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ForgotPwdState extends Equatable {
  ForgotPwdState([List props = const []]) : super(props);
}

class InitialForgotPwdState extends ForgotPwdState {}

class ForgotPwdLoading extends ForgotPwdState {
  @override
  String toString() {
    return 'ForgotPwdLoading';
  }
}

class ForgotPwdFailed extends ForgotPwdState {
  final String error;

  ForgotPwdFailed({this.error}) : super([error]);

  @override
  String toString() {
    return 'ForgotPwdFailed -  $error';
  }
}

class ForgotPwdStatus extends ForgotPwdState {
  final bool value;
  ForgotPwdStatus({@required this.value}) : super([value]);

  @override
  String toString() {
    return 'ForgotPwdStatus - $value';
  }
}

class ForgotPwdSendAuthenticationCodeStatus extends ForgotPwdState {
  final bool value;
  ForgotPwdSendAuthenticationCodeStatus({@required this.value}) : super([value]);

  @override
  String toString() {
    return 'ForgotPwdSendAuthenticationCodeStatus - $value';
  }
}

class ForgotPwdCheckAuthenticationCodeStatus extends ForgotPwdState {
  final bool value;
  ForgotPwdCheckAuthenticationCodeStatus({@required this.value}) : super([value]);

  @override
  String toString() {
    return 'ForgotPwdCheckAuthenticationCodeStatus - $value';
  }
}

class ForgotPwdResetStatus extends ForgotPwdState {
  final bool value;
  ForgotPwdResetStatus({@required this.value}) : super([value]);

  @override
  String toString() {
    return 'ForgotPwdResetStatus - $value';
  }
}

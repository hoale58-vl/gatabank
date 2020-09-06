import 'package:flutter/cupertino.dart';

abstract class LoginState {
  LoginState() : super();
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginSendingOtp extends LoginState {
  String phone;
  LoginSendingOtp({@required this.phone}) : super();

  @override
  String toString() => 'LoginSendingOtp';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  @override
  String toString() => 'LoginFailure';
}

class LoginSuccess extends LoginState {
  @override
  String toString() => 'LoginSuccess';
}

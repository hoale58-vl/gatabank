import 'package:meta/meta.dart';

abstract class LoginEvent {
  LoginEvent() : super();
}

class LoginButtonPressed extends LoginEvent {
  final String phone;
  LoginButtonPressed({@required this.phone}) : super();
  @override
  String toString() => 'LoginButtonPressed { phone: $phone }';
}

class OtpButtonPressed extends LoginEvent {
  final String phone;
  final String otp;
  OtpButtonPressed({@required this.phone, @required this.otp}) : super();
  @override
  String toString() => 'OtpButtonPressed { otp: $otp, phone: $phone }';
}
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String referralCode;
  final bool isCheckTermAndAgreement;

  RegisterButtonPressed(
      {@required this.email,
        @required this.password,
        @required this.confirmPassword,
        @required this.referralCode,
        @required this.isCheckTermAndAgreement})
      : super([email, password, confirmPassword, referralCode, isCheckTermAndAgreement]);

  @override
  String toString() =>
      'RegisterButtonPressed { email: $email, password: $password, confirmPassword: $confirmPassword, check: $isCheckTermAndAgreement }';
}

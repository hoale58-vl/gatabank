import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ForgotPwdEvent extends Equatable {
  ForgotPwdEvent([List props = const []]) : super(props);
}

class ForgotPwdStarted extends ForgotPwdEvent {}

class ForgotPwdCheckEmail extends ForgotPwdEvent {
  final String email;
  ForgotPwdCheckEmail({@required this.email}) : super([email]);

  @override
  String toString() => 'ForgotPwdCheckEmail: $email';
}

class ForgotPwdSendEmail extends ForgotPwdEvent {
  final String email;
  final bool resend;
  ForgotPwdSendEmail({@required this.email, this.resend = true}) : super([email, resend]);

  @override
  String toString() => 'ForgotPwdSendEmail $email - $resend';
}

class ForgotPwdCheckAuthenticationCode extends ForgotPwdEvent {
  final String email;
  final String authenticationCode;
  ForgotPwdCheckAuthenticationCode({@required this.email, @required this.authenticationCode})
      : super([email, authenticationCode]);

  @override
  String toString() => 'ForgotPwdCheckAuthenticationCode: $email, $authenticationCode';
}

class ForgotPwdResetNewOne extends ForgotPwdEvent {
  final String email;
  final String authenticationCode;
  final String newPassword;
  final String confirmNewPassword;

  ForgotPwdResetNewOne({
    @required this.email,
    @required this.authenticationCode,
    @required this.newPassword,
    @required this.confirmNewPassword,
  }) : super([email, authenticationCode, newPassword, confirmNewPassword]);

  @override
  String toString() =>
      'ForgotPwdResetNewOne: $email, $authenticationCode, $newPassword, $confirmNewPassword';
}

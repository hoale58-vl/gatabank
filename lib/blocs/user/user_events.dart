
import 'package:equatable/equatable.dart';
import 'package:gatabank/screens/account/verification_code.dart';

abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class UserStarted extends UserEvent {
  @override
  String toString() => 'UserStarted';
}

class UserGetProfile extends UserEvent {
  @override
  String toString() => 'UserGetProfile';
}

class UserSendVerification extends UserEvent {
  final ValidationType verifyType;
  final String email;
  final String phone;
  final String countryCode;
  final String recaptchaToken;

  UserSendVerification(this.verifyType,
      {this.email, this.phone, this.countryCode, this.recaptchaToken})
      : super([verifyType]);

  @override
  String toString() => 'UserSendVerification';
}

class UserCheckVerification extends UserEvent {
  final ValidationType verifyType;
  final String email;
  final String verificationCode;
  final String phone;
  final String countryCode;
  final String firebaseSID;

  UserCheckVerification(this.verifyType, this.verificationCode,
      {this.email, this.firebaseSID, this.phone, this.countryCode})
      : super([verifyType]);

  @override
  String toString() => 'UserCheckVerification';
}

class UserCheckPhoneNumber extends UserEvent {
  final String countryCode;
  final String phone;

  UserCheckPhoneNumber(this.countryCode, this.phone) : super([countryCode, phone]);

  @override
  String toString() => 'UserCheckPhoneNumber';
}

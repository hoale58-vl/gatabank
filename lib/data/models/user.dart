import 'package:meta/meta.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/theme/themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gatabank/screens/account/verification_code.dart';

class VerificationLevel {
  final icon, value;
  final ValidationType verifiedType;

  const VerificationLevel._internal(this.icon, this.value, {this.verifiedType});

  toString() => 'Enum.$value';

  getName() {
    if (value == Email.value)
      return LocaleKeys.account_email.tr();
    else if (value == Phone.value) return LocaleKeys.account_mobile_number.tr();
    return LocaleKeys.account_identity_document.tr();
  }

  static const Email =
  const VerificationLevel._internal('email', 1, verifiedType: ValidationType.VerificationEmail);
  static const Phone =
  const VerificationLevel._internal('phone', 2, verifiedType: ValidationType.VerificationPhone);

  static getVerifiedLevel(int value) {
    if (value == Email.value)
      return Email;
    else if (value == Phone.value) return Phone;
  }

  static const verificationTypes = [Email, Phone];
}

class VerificationStatus {
  final value, clickable;

  const VerificationStatus._internal(this.value, this.clickable);

  toString() => 'Enum.$value';

  getName() {
    if (value == NotVerified.value)
      return LocaleKeys.account_not_verified.tr();
    else if (value == InReview.value)
      return LocaleKeys.account_in_review.tr();
    else if (value == VerifiedFailed.value) return LocaleKeys.account_verified_failed.tr();
    return LocaleKeys.account_verified.tr();
  }

  getTitle() {
    if (value == Verified.value)
      return LocaleKeys.account_congratulations.tr();
    else if (value == InReview.value) return LocaleKeys.account_your_account_is_in_review.tr();
    return LocaleKeys.account_your_account_has_not_been.tr();
  }

  getDescription() {
    if (value == Verified.value)
      return LocaleKeys.account_your_account_has_been_verified.tr();
    else if (value == InReview.value) return LocaleKeys.account_we_will_send_you_an_email.tr();
    return LocaleKeys.account_for_your_security_you_should_complete.tr();
  }

  static const NotVerified = const VerificationStatus._internal(0, true);
  static const InReview = const VerificationStatus._internal(1, false);
  static const Verified = const VerificationStatus._internal(2, false);
  static const VerifiedFailed = const VerificationStatus._internal(3, true);

  static getVerifiedStatus(int value) {
    if (value == Verified.value)
      return Verified;
    else if (value == InReview.value)
      return InReview;
    else if (value == VerifiedFailed.value) return VerifiedFailed;
    return NotVerified;
  }

  static getColor(VerificationStatus status) {
    Colours colours = App.theme.colors;
    switch (status) {
      case NotVerified:
      case VerifiedFailed:
        return colours.fail;
      case Verified:
        return colours.success;
      default:
        return colours.pending;
    }
  }
}

class User {
  int id;
  String fullName;
  String email;
  String phone, countryCode;
  int emailVerification, phoneVerification;
  bool enableNotification = false;

  User(
      {this.id,
        this.fullName,
        this.phone,
        this.countryCode,
        this.emailVerification,
        this.phoneVerification,
        this.enableNotification,
        @required this.email});

  static const KEY_ID = 'id';
  static const KEY_FULL_NAME = 'full_name';
  static const KEY_PHONE = 'phone';
  static const KEY_EMAIL = 'email';
  static const KEY_EMAIL_VERIFICATION = 'email_verification';
  static const KEY_PHONE_VERIFICATION = 'phone_verification';
  static const KEY_COUNTRY_CODE = 'country_code';
  static const KEY_ENABLE_NOTIFICATION = 'enable_notification';
  static const KEY_CRYPTO_PASS_PHASE = 'crypto_passphase';

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      KEY_ID: id,
      KEY_FULL_NAME: fullName,
      KEY_PHONE: phone,
      KEY_EMAIL: email,
      KEY_EMAIL_VERIFICATION: emailVerification,
      KEY_PHONE_VERIFICATION: phoneVerification,
      KEY_COUNTRY_CODE: countryCode,
      KEY_ENABLE_NOTIFICATION: enableNotification
    };
    return map;
  }

  get fullPhoneNumber => '$countryCode$phone';

  User.fromJson(Map<String, dynamic> map) {
    id = map[KEY_ID] as int;
    fullName = map[KEY_FULL_NAME] as String;
    phone = map[KEY_PHONE] as String;
    email = map[KEY_EMAIL] as String;
    emailVerification = map[KEY_EMAIL_VERIFICATION];
    phoneVerification = map[KEY_PHONE_VERIFICATION];
    countryCode = map[KEY_COUNTRY_CODE];
    enableNotification = map[KEY_ENABLE_NOTIFICATION];
  }

  VerificationStatus get emailStatus => VerificationStatus.getVerifiedStatus(emailVerification);

  VerificationStatus get phoneStatus => VerificationStatus.getVerifiedStatus(phoneVerification);

  VerificationStatus get verifiedStatus {
    if (emailStatus == VerificationStatus.NotVerified ||
        phoneStatus == VerificationStatus.NotVerified) return VerificationStatus.NotVerified;
    if (emailStatus == VerificationStatus.InReview ||
        phoneStatus == VerificationStatus.InReview) return VerificationStatus.InReview;
    return VerificationStatus.Verified;
  }

  VerificationStatus getVerifiedStatus(VerificationLevel verificationLevel) {
    switch (verificationLevel) {
      case VerificationLevel.Email:
        return emailStatus;
      case VerificationLevel.Phone:
        return phoneStatus;
    }
  }

  get isInReview =>
      emailStatus == VerificationStatus.Verified &&
          phoneStatus == VerificationStatus.Verified;

  @override
  String toString() {
    return ('id: ${this.id} - full name: ${this.fullName}');
  }
}

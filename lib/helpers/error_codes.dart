import 'package:gatabank/helpers/lang/locale_keys.g.dart';

abstract class ErrorCodes {
  static final Map errorCodes = {
    1506: LocaleKeys.error_referral_code_is_invalid,
    200: LocaleKeys.error_invalid_email,
    203: LocaleKeys.error_invalid_email_or_password,
    220: LocaleKeys.error_invalid_mobile_number,
    221: LocaleKeys.error_phone_is_not_available,
    301: LocaleKeys.error_please_input_verification_code,
    214: LocaleKeys.error_invalid_code,
  };
}

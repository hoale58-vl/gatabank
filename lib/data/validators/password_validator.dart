import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class PasswordFieldValidator {
  static String validate(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return LocaleKeys.auth_password_cannot_be_empty.tr();
    }

    if (value.length < 6) {
      return LocaleKeys.auth_password_must_at_least_6_characters.tr();
    }

    return null;
  }
}

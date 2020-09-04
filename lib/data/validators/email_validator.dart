import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class EmailFieldValidator {
  static String validate(String value) {
    if (!Utils.isValidEmail(value) || value.isEmpty) {
      return LocaleKeys.auth_email_is_invalid.tr();
    }
    return null;
  }
}

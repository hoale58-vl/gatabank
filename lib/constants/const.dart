import 'package:flutter/services.dart';
import 'package:gatabank/helpers/comma_formatter.dart';
import 'package:gatabank/helpers/decimal_formatter.dart';

class CONST {
  static const CRYPTO_PASSPHASE = 'CRYPTO_PASSPHASE';

  // User token
  static const JWT_TOKEN = 'jwt_token';

  static const SQLITE_TRUE = 1;
  static const SQLITE_FALSE = 0;

  static const AMOUNT_PLACEHOLDER = "0.00";

  static const DECIMALS_AMOUNT_LIMIT = 8;
  static final amountInputFormatters = [
    CommaTextInputFormatter(),
    DecimalTextInputFormatter(decimalRange: CONST.DECIMALS_AMOUNT_LIMIT),
    WhitelistingTextInputFormatter(RegExp("[0-9\.]"))
  ];

  static const RESPONSE_RESULT_KEY = 'Result';
  static const RESPONSE_ERROR_KEY = 'Error';
  static const RESPONSE_ERROR_MESSAGE_KEY = 'Message';
  static const RESPONSE_ERROR_CODE_KEY = 'Code';

  //Settings
  static const SETTING_APP_LOCK = 'SETTING_APP_LOCK';
  static const SETTING_PASSCODE = 'SETTING_PASSCODE';
  static const PASSCODE_LENGTH = 6;
  static const SETTING_APP_LOCK_METHOD = 'SETTING_APP_LOCK_METHOD';
  static const SETTING_APP_LOCK_METHOD_PASSCODE = 'SETTING_APP_LOCK_METHOD_PASSCODE';
  static const SETTING_APP_LOCK_METHOD_BIOMETRIC = 'SETTING_APP_LOCK_METHOD_BIOMETRIC';
  static const PREF_IS_FCM_TOKEN_ADDED = 'PREF_IS_FCM_TOKEN_ADDED';
  static const PREF_LAST_FCM_TOKEN = 'PREF_LAST_FCM_TOKEN';

  static const APP_LOCK_METHODS = [
    CONST.SETTING_APP_LOCK_METHOD_PASSCODE,
    CONST.SETTING_APP_LOCK_METHOD_BIOMETRIC,
  ];

  static const SETTING_APP_LOCK_METHOD_TITLE = ["Passcode", "Touch ID / Face ID"];
}

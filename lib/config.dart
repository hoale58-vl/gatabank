
import 'package:gatabank/theme/themes.dart';

class App {
  static Themes theme;
  static String referralCode;
}

enum Environment { Local, Dev, Prod }

class Config {
  static Map<String, dynamic> _config;

  static get baseURL {
    return _config[_ConfigMap.BASE_URL];
  }

  static get captchaUrl {
    return _config[_ConfigMap.CAPTCHA_URL];
  }

  static get captchaApiKey {
    return _config[_ConfigMap.CAPTCHA_API_KEY];
  }
}

class _ConfigMap {
  static const BASE_URL = "BASE_URL";
  static const CAPTCHA_API_KEY = "CAPTCHA_API_KEY";
  static const CAPTCHA_URL = "CAPTCHA_URL";
}

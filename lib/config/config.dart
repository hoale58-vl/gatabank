import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/helpers/theme/themes.dart';

class App {
  // This contains global variables. We should avoid using this in case you have special reason.
  static User user;
  static Themes theme;
  static String referralCode;
}

enum Environment { Local, Dev, Prod }

class Config {
  static Map<String, dynamic> _config;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.Local:
        _config = _ConfigMap.localConfig;
        break;
      case Environment.Dev:
        _config = _ConfigMap.devConfig;
        break;
      case Environment.Prod:
        _config = _ConfigMap.prodConfig;
        break;
    }
  }

  static bool isProd() => _config == _ConfigMap.prodConfig;

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

  static Map<String, dynamic> localConfig = {
    BASE_URL: "http://localhost:6000/api",
    CAPTCHA_API_KEY: "6LcMZR0UAAAAALgPMcgHwga7gY5p8QMg1Hj-bmUv",
    CAPTCHA_URL: "https://storage.googleapis.com/storage.tokoin.co/RECAPTCHA-MOBILE.htm",
  };

  static Map<String, dynamic> devConfig = {
    BASE_URL: "https://staging.tokoin.io/api",
    CAPTCHA_URL: "https://storage.tokoin.co/RECAPTCHA-MOBILE.htm",
    CAPTCHA_API_KEY: "6LcMZR0UAAAAALgPMcgHwga7gY5p8QMg1Hj-bmUv",
  };

  static Map<String, dynamic> prodConfig = {
    BASE_URL: "https://prod.tokoin.io/api",
    CAPTCHA_URL: "https://wallet-prod-storage.tokoin.io/RECAPTCHA-MOBILE.htm",
    CAPTCHA_API_KEY: "6LcMZR0UAAAAALgPMcgHwga7gY5p8QMg1Hj-bmUv",
  };
}

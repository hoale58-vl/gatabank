import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/helpers/error_codes.dart';
import 'package:gatabank/helpers/utils.dart';

abstract class BaseAPI {
  Future<Response> auth(String email, String password);

  Future<Response> signup(
      {String email, String password, String confirmPassword, String referralCode});

  Future<Response> userInfo();

  Future<Response> addFcmToken(String token, String fcmToken);

  Future<Response> checkEmailExist(String email);

  Future<Response> checkPhoneExist(String countryCode, phone);

  Future<Response> sendAuthenticationCode(String email, bool resend);

  Future<Response> checkAuthenticationCode(String email, authenticationCode);

  Future<Response> resetPwd(String email, authenticationCode, newPassword, confirmNewPassword);

  Future<Response> updateUser(User user);

  Future<Response> sendOTP(String recaptchaToken, String phone, String countryCode);

  Future<Response> checkOTP(String code, String firebaseSID);

  Future<Response> sendEmailVerificationCode();

  Future<Response> checkEmailVerificationCode(String code);

  Future<Response> getReferral();

  Future<Response> getRewardList(page);
}

class APIUnauthorizedException implements Exception {}

class API extends BaseAPI {
  static final API _singleton = new API._internal();
  Dio _dio;
  List<Function> _onErrorCallbacks = [];

  factory API() {
    return _singleton;
  }

  API._internal() {
    _dio = Dio();
    _dio.options.baseUrl = Config.baseURL;
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;
    _dio.options.responseType = ResponseType.json;

    _dio.interceptors.add(_logging());
  }

  _logging() {
    return InterceptorsWrapper(onRequest: (RequestOptions options) async {
      utils.log("DIO - REQUEST: [${options.method}] ${options.path}} \nbody:${options.data}");

      return options;
    }, onResponse: (Response response) async {
      utils.log("DIO - RESPONSE: [${response.request.method}] ${response.request.path} "
          "${response.statusCode} [OK]\n"
          "body:${response.request.data}\n"
          "response:${response.data}");
      return response;
    }, onError: (DioError e) async {
      utils.logError(
          exception: Exception(e),
          content:
          "DIO - ERROR: ${e.request.path}\ndata: ${e.request.data}\nresponse:${e.response.data}");
      if (e.response.statusCode == HttpStatus.unauthorized) {
        publishToErrorCallbacks(APIUnauthorizedException());
      } else {
        publishToErrorCallbacks(e);
      }
      return e;
    });
  }

  Future<Response> auth(String email, password) async {
    return await _dio.post("/auth/login", data: {"Email": email, "Password": password});
  }

  Future<Response> signup({String email, password, confirmPassword, referralCode}) async {
    return await _dio.post("/auth/register", data: {
      "Email": email,
      "Password": password,
      "ConfirmPassword": confirmPassword,
      "ReferralCode": referralCode
    });
  }

  Future<Response> userInfo() async {
    await _addAuthHeader();
    return await _dio.get("/auth/user-profile");
  }

  static const ITEMS_PER_PAGE = 10;

  Future<Response> addFcmToken(String token, String fcmToken) async {
    _dio.options.headers['Authorization'] = 'Bearer ' + token;
    return await _dio.post("/device/add", data: {"Token": fcmToken});
  }

  @override
  Future<Response> checkEmailExist(email) async {
    return await _dio.get("/check-email-exist?email=$email");
  }

  @override
  Future<Response> sendAuthenticationCode(String email, bool resend) async {
    return await _dio.post("/forgot-pwd", data: {"Email": email, "Resend": resend});
  }

  @override
  Future<Response> checkAuthenticationCode(String email, authenticationCode) async {
    return await _dio
        .post("/check-authentication-code", data: {"Email": email, "Code": authenticationCode});
  }

  @override
  Future<Response> resetPwd(
      String email, authenticationCode, newPassword, confirmNewPassword) async {
    return await _dio.post("/reset-pwd", data: {
      "Email": email,
      "Code": authenticationCode,
      "NewPassword": newPassword,
      "ConfirmNewPassword": confirmNewPassword
    });
  }

  Future<Response> getPrograms() async {
    await _addAuthHeader();
    return await _dio.get("/program/list");
  }

  Future<void> _addAuthHeader() async {
    _dio.options.headers['Authorization'] = 'Bearer ' + await utils.getToken();
  }

  Future<Response> getVersion() async {
    await _addAuthHeader();
    return await _dio.get("/force-update");
  }

  void onError(callback) {
    _onErrorCallbacks.add(callback);
  }

  void publishToErrorCallbacks(Exception error) {
    _onErrorCallbacks.forEach((callback) {
      callback(error);
      if (error is DioError) {
        if (error.response.statusCode == HttpStatus.badRequest ||
            error.response.statusCode == HttpStatus.internalServerError) {
          var data = error.response.data;
          int errorCode = data['Error']['Code'];
          if (ErrorCodes.errorCodes.containsKey(errorCode))
            throw Exception(ErrorCodes.errorCodes[errorCode]);
        }
      }
    });
  }

  Future<Response> updateUser(User user) async {
    await _addAuthHeader();
    return await _dio.put("/auth/user-profile", data: user.toJson());
  }

  @override
  Future<Response> getReferral() async {
    return await _dio.get("/referral/detail");
  }

  @override
  Future<Response> getRewardList(page) async {
    return await _dio.get("/referral/reward/list?page=$page&limit=$ITEMS_PER_PAGE");
  }

  @override
  Future<Response> sendOTP(String recaptchaToken, String phone, String countryCode) async {
    return await _dio.post('/verification-code/otp/send', data: {
      "recaptcha_token": recaptchaToken,
      "phone": phone,
      "country_code": countryCode,
    });
  }

  @override
  Future<Response> checkOTP(String code, String firebaseSID) async {
    return await _dio
        .post('/verification-code/otp/check', data: {"code": code, "firebase_sid": firebaseSID});
  }

  @override
  Future<Response> checkEmailVerificationCode(String code) async {
    return await _dio.post('/verification-code/email/check', data: {"code": code});
  }

  @override
  Future<Response> sendEmailVerificationCode() async {
    return await _dio.post('/verification-code/email/send', data: null);
  }

  @override
  Future<Response> checkPhoneExist(String countryCode, phone) async {
    return await _dio.post('/verification-code/phone/check-exist',
        data: {"country_code": countryCode, "phone": phone});
  }

}

final api = new API();


import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gatabank/Utils.dart';

class APIUnauthorizedException implements Exception {}

class API  {
  static final API _singleton = new API._internal();
  Dio _dio;
  List<Function> _onErrorCallbacks = [];

  factory API() {
    return _singleton;
  }

  API._internal() {
    _dio = Dio();
    _dio.options.baseUrl = "";
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 3000;
    _dio.options.responseType = ResponseType.json;

    _dio.interceptors.add(_logging());
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
            throw Exception(error.response.data);
        }
      }
    });
  }

  _logging() {
    return InterceptorsWrapper(onRequest: (RequestOptions options) async {
      Utils.log("DIO - REQUEST: [${options.method}] ${options.path}} \nbody:${options.data}");

      return options;
    }, onResponse: (Response response) async {
      Utils.log("DIO - RESPONSE: [${response.request.method}] ${response.request.path} "
          "${response.statusCode} [OK]\n"
          "body:${response.request.data}\n"
          "response:${response.data}");
      return response;
    }, onError: (DioError e) async {
      Utils.log("DIO - ERROR: ${e.request.path}\ndata: ${e.request.data}\nresponse:${e.response.data}");
      if (e.response.statusCode == HttpStatus.unauthorized) {
        publishToErrorCallbacks(APIUnauthorizedException());
      } else {
        publishToErrorCallbacks(e);
      }
      return e;
    });
  }

  Future<Response> sendOTP({String phone}) async {
    return await _dio.post('/otp/send', data: {
      "phone": phone
    });
  }

  Future<Response> verifyOtp({String phone, String otp}) async {
    return await _dio.post('/otp/verify', data: {
      "phone": phone,
      "otp": otp
    });
  }

  Future<Response> addFcmToken(String token, String fcmToken) async {
    _dio.options.headers['Authorization'] = 'Bearer ' + token;
    return await _dio.post("/device/add", data: {"Token": fcmToken});
  }

  Future<Response> updateInfo({String userId, Map<String, dynamic> json}) async {
    return await _dio.put('/user/$userId', data: json);
  }

  Future<Response> listBanks() {

  }

  void addErrorInterceptor(callback) {
    _onErrorCallbacks.add(callback);
  }
}

final api = new API();
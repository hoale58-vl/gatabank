import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gatabank/api.dart';
import 'package:gatabank/consts.dart';
import 'package:gatabank/mocks/api.dart';
import 'package:gatabank/mocks/data.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/models/user.dart';
import 'package:mockito/mockito.dart';

class UserRepository {
  final API api;
  UserRepository({
    @required this.api,
  })  : assert(api != null){
    if (api is MockAPI){
      when(api.sendOTP(phone: captureAnyNamed("phone"))).thenAnswer(successResponse({}));
      when(api.verifyOtp(phone: captureAnyNamed("phone"), otp: captureAnyNamed("otp"))).thenAnswer(successResponse(UserMockData.login()));
      when(api.updateInfo(userId: captureAnyNamed("userId"), json: captureAnyNamed("json"))).thenAnswer(successResponse({}));
    }
  }

  Future<bool> sendOTP(phone) async {
    print(phone);
    var response = await api.sendOTP(phone: phone);
    return response.statusCode == 200;
  }

  Future<User> verifyOtp(String phone, String otp) async {
    var response = await api.verifyOtp(phone: phone, otp: otp);
    if (response.statusCode == 200){
      return User.fromJson(response.data);
    }
    return null;
  }

  User currentUser() {
    return storage.getUser();
  }

  Future<bool> logout() async {
    await storage.deleteSecureData(CONST.JWT_TOKEN);
    await storage.clearUserPref();
    return true;
  }

  Future<User> updateInfo({
    @required int income,
    @required int loanExpected,
    @required int loanTerm,
    @required String address,
    @required String salaryReceiveMethod
  }) async {
    User user = currentUser();
    user.income = income;
    user.loanExpected = loanExpected;
    user.loanTerm = loanTerm;
    user.address = address;
    user.salaryReceiveMethod = salaryReceiveMethod;
    var response = await api.updateInfo(userId: user.id, json: user.toJson());
    return response.statusCode == 200 ? user : null;
  }
}
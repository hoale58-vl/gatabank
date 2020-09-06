import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gatabank/consts.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/models/user.dart';
import '../api.dart';

class UserRepository {
  final API api;
  UserRepository({
    @required this.api,
  })  : assert(api != null);

  Future<bool> sendOTP({String phone}) async {
    var response = await api.sendOTP(phone);
    return response.statusCode == 200;
  }

  Future<User> verifyOtp({String phone, String otp}) async {
    var response = await api.verifyOtp(phone, otp);
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

  Future<bool> addFcmToken({@required fcmToken}) async {
    var response = await api.addFcmToken(await storage.getSecureData(CONST.JWT_TOKEN), fcmToken);
    return response.statusCode != HttpStatus.ok;
  }

}
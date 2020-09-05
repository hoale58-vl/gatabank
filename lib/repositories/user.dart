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

  Future<String> sendOTP({String phone}) async {
    var response = await api.sendOTP(phone);
    Map<String, dynamic> map = response.data;
    return map['Result']['firebase_sid'];
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
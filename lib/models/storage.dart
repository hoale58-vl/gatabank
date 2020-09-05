import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gatabank/consts.dart';
import 'package:gatabank/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SHOULD_SHOW_ONBOARDING = 'SHOULD_SHOW_ONBOARDING';
const THEME_MODE = 'THEME_MODE';
const USER_DATA = 'USER_DATA';

class Storage {
  static final Storage _singleton = new Storage._internal();
  SharedPreferences _prefs;
  FlutterSecureStorage securedStorage;

  factory Storage() {
    return _singleton;
  }

  Storage._internal(){
    securedStorage = new FlutterSecureStorage();
  }

  Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<void> saveBoolean(String key, bool value) async {
    _prefs.setBool(key, value);
  }

  Future<bool> getBoolean(String key) async {
    return _prefs.getBool(key) ?? false;
  }

  Future<void> saveString(String key, String value) async {
    _prefs.setString(key, value);
  }

  Future<void> remove(String key) async {
    _prefs.remove(key);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  Future<void> saveInt(String key, int value) async {
    _prefs.setInt(key, value);
  }

  Future<int> getInt(String key) async {
    return _prefs.getInt(key) ?? -1;
  }

  Future<void> saveDouble(String key, double value) async {
    _prefs.setDouble(key, value);
  }

  Future<double> getDouble(String key) async {
    return _prefs.getDouble(key) ?? 0;
  }

  clearUserPref() {
    saveBoolean(CONST.PREF_IS_FCM_TOKEN_ADDED, false);
    saveString(CONST.PREF_LAST_FCM_TOKEN, '');
    saveString(USER_DATA, '');
  }

  saveUser(User user) {
    String json = jsonEncode(user);
    saveString(USER_DATA, json);
  }

  User getUser() {
    String json = getString(USER_DATA);
    if (json.isEmpty) return null;
    Map userMap = jsonDecode(json);
    return User.fromJson(userMap);
  }

  Future<void> saveSecureData(String key, String value) async {
    securedStorage.write(key: key, value: value);
  }

  Future<String> getSecureData(String key) async {
    return await securedStorage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await securedStorage.delete(key: key);
  }
}

final storage = Storage();

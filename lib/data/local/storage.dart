import 'dart:convert';

import 'package:gatabank/constants/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/helpers/theme/theme_provider.dart';
import 'package:gatabank/helpers/utils.dart';

const SHOULD_SHOW_ONBOARDING = 'SHOULD_SHOW_ONBOARDING';
const THEME_MODE = 'THEME_MODE';
const USER_DATA = 'USER_DATA';
// consider clear user data when sign out in clearUserPref()

class Storage {
  static final Storage _singleton = new Storage._internal();
  SharedPreferences _prefs;

  factory Storage() {
    return _singleton;
  }

  Storage._internal();

  Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  registerTestPreference(SharedPreferences sharedPreferences) {
    _prefs = sharedPreferences;
  }

  bool isOnboardingEnabled() {
    return _prefs.getBool(SHOULD_SHOW_ONBOARDING) ?? true;
  }

  disableOnboarding() {
    _prefs.setBool(SHOULD_SHOW_ONBOARDING, false);
  }

  ThemeMode getThemeMode() {
    ThemeEnum themeEnum = ThemeEnum.getThemeByThemeMode(_prefs.getString(THEME_MODE));
    return themeEnum.themeMode;
  }

  setThemeMode(ThemeMode themeMode) {
    _prefs.setString(THEME_MODE, themeMode.toString());
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

  _getInterestKey(int programId, int planId, bool isData) =>
      'programId:$programId-planId:$planId${isData ? '-data' : '-time'}';

  Future<String> getCachedInterests(int programId, int planId) async {
    var cachedTime = await storage.getInt(_getInterestKey(programId, planId, false));
    var data = storage.getString(_getInterestKey(programId, planId, true));
    DateTime cachedDate = DateTime.fromMillisecondsSinceEpoch(cachedTime * 1000);
    return DateTime.now().difference(cachedDate).inDays == 0 ? data : null;
  }

  cacheInterests(int programId, int planId, String data) {
    saveString(_getInterestKey(programId, planId, true), data);
    saveInt(_getInterestKey(programId, planId, false), utils.currentTimeInSeconds());
  }

  saveUser(User user) {
    String json = jsonEncode(user);
    saveString(USER_DATA, json);
  }

  User getUser() {
    String json = getString(USER_DATA);
    if (utils.isEmptyString(json)) return null;
    Map userMap = jsonDecode(json);
    return User.fromJson(userMap);
  }
}

final storage = Storage();

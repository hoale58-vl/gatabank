import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:gatabank/config/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gatabank/constants/const.dart';

class Utils {
  static final Utils _singleton = new Utils._internal();
  var storage;

  factory Utils() {
    return _singleton;
  }

  Utils._internal() {
    storage = new FlutterSecureStorage();
  }

  // only use this if reuse image for both dark & light theme
  // otherwise using getSvgPicture in Themes class
  static getSvgPicture(String name) => SvgPicture.asset('assets/$name.svg');

  static bool get isInDebugMode {
    return !kReleaseMode;
  }

  static bool isValidEmail(String email) {
    String p = r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }

  Future<void> saveSecureData(String key, String value) async {
    storage.write(key: key, value: value);
  }

  Future<String> getSecureData(String key) async {
    return await storage.read(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await storage.delete(key: key);
  }

  registerNewSecureStorage(FlutterSecureStorage secureStorage) {
    storage = secureStorage;
  }

  static DateFormat _dateFormat;

  String convertToDateString(DateTime date) {
    if (_dateFormat == null) _dateFormat = DateFormat('d MMM yyyy');
    return _dateFormat.format(date);
  }

  static DateFormat _timeFormat;

  String convertToTimeString(DateTime date) {
    if (_timeFormat == null) _timeFormat = DateFormat('hh:mm a');
    return _timeFormat.format(date);
  }

  static DateFormat _dateTimeFormat;

  String convertToDateTimeString(DateTime date) {
    if (_dateTimeFormat == null) _dateTimeFormat = DateFormat('hh:mm a - d MMM yyyy');
    return _dateTimeFormat.format(date);
  }

  log(dynamic str) {
    if (Config.isProd()) return;
    print('\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n'
        '$str'
        '\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');
  }

  logError({Exception exception, dynamic error, dynamic content}) {
    Crashlytics crashlytics = Crashlytics.instance;
    crashlytics.setUserEmail(App.user?.email ?? 'anonymous');

    if (exception == null) exception = Exception(error);
    crashlytics.recordError(exception, null, context: content);

    if (!Config.isProd() && content != null) utils.log(content);
  }

  toast(dynamic str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  errorToast(dynamic str) {
    Fluttertoast.showToast(
        msg: str,
        timeInSecForIos: 3,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: App.theme.colors.error,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  /// the current time, in “seconds since the epoch”
  int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  Future<String> getToken() async {
    String token = await utils.getSecureData(CONST.JWT_TOKEN);

    if (token == null)
      throw ('Token is not in secure data');
    else
      log(token);
    return token;
  }

  Future<int> getBuildNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return int.parse(packageInfo.buildNumber.toString());
  }

  dynamic findMapKeyByValue(Map<dynamic, dynamic> map, value) {
    return map.keys.firstWhere((k) => map[k] == value, orElse: () => null);
  }

  bool isEmptyString(String amountStr) {
    return amountStr == null || amountStr.isEmpty;
  }

  static bool isDebugging = false;

}

final utils = new Utils();

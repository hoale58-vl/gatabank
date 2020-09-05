import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatabank/config.dart';

class Utils {
  static final Utils _singleton = new Utils();
  var storage;

  factory Utils() {
    return _singleton;
  }

  static getSvgPicture(String name) => SvgPicture.asset('assets/$name.svg');

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

  log(dynamic str) {
    print('\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n'
        '$str'
        '\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');
  }
}

final utils = new Utils();

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatabank/config.dart';

class Utils {

  static getSvgPicture(String name) => SvgPicture.asset('assets/$name.svg');

  static toast(dynamic str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  static errorToast(dynamic str) {
    Fluttertoast.showToast(
        msg: str,
        timeInSecForIos: 3,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: App.theme.colors.error,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static log(dynamic str) {
    print('\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n'
        '$str'
        '\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n');
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatabank/config.dart';
import "package:intl/intl.dart";

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

  static currencyFormat(int value){
    return NumberFormat.currency(locale: 'vi').format(value);
  }

  static void showCustomDialog(BuildContext context, {String title, String content, VoidCallback onSubmit}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Đồng ý"),
              onPressed: () {
                onSubmit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String localeCurrency(double money, {String symbol, int decimalDigits = 0}) {
    var currencyFormat = NumberFormat.currency(
        locale: "vi-VN",
        decimalDigits: decimalDigits,
        symbol: symbol
    );
    return currencyFormat.format(money);
  }
}


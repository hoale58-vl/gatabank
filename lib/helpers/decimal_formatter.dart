import 'package:flutter/services.dart';

/* Limit decimalRange for input field */

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;
      int dotIndex = value.indexOf(".");

      if (value.contains(".") && value.substring(dotIndex + 1).length > decimalRange) {
        truncated =
            value.substring(0, dotIndex) + value.substring(dotIndex, dotIndex + decimalRange + 1);
      } else if (value == ".") {
        truncated = "0.";
      }
      newSelection = newValue.selection.copyWith(
        baseOffset: truncated.length,
        extentOffset: truncated.length,
      );

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

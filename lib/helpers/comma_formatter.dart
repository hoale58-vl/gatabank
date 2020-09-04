import 'package:flutter/services.dart';

/* In some region such as Indonesia, iOS keyboard will show comma instead of dot for decimal input,
  hence users cannot input decimal number as the app rejects comma signal,
 using this input formatter helps to convert comma to dot at runtime */

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String truncated = newValue.text;
    TextSelection newSelection = newValue.selection;

    if (newValue.text.contains(",")) {
      truncated = newValue.text.replaceFirst(RegExp(','), '.');
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
    );
  }
}

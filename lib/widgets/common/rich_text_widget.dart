import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RichTextWidget extends StatelessWidget {
  final String text, highlightText;
  final TextStyle textStyle, highlightTextStyle;
  final TextAlign textAlign;

  RichTextWidget(
      {@required this.text,
        @required this.highlightText,
        @required this.textStyle,
        @required this.highlightTextStyle,
        this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    if (highlightText == null)
      return Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      );
    int highlightIndex = text.indexOf(highlightText);
    assert(highlightIndex >= 0);
    String startText = text.substring(0, highlightIndex);
    String endText = text.substring(highlightIndex + highlightText.length, text.length);
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        text: startText,
        style: textStyle,
        children: <TextSpan>[
          TextSpan(text: highlightText, style: highlightTextStyle),
          TextSpan(text: endText),
        ],
      ),
    );
  }
}

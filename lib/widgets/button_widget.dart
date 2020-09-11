import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gatabank/theme/themes.dart';

import '../config.dart';

const DEFAULT_HEIGHT = 35.0;
const DEFAULT_BORDER_WIDTH = 1.0;
const DEFAULT_MARGIN = const EdgeInsets.symmetric(horizontal: 0);

enum ButtonType { blue_filled, gray_filled, orange_filled, red_filled, white_filled, blue_border, white_border, transparent }

class ButtonWidget extends StatefulWidget {
  final Function onPressed;
  final String title;
  final ButtonType buttonType;
  final TextStyle textStyle;
  final EdgeInsetsGeometry margin;
  final bool loading;
  final bool enabled;
  final bool upperCase;
  final double height;
  final BorderRadius borderRadius;
  final double borderWidth;
  final bool fullWidth;

  const ButtonWidget(
      {Key key,
        @required this.onPressed,
        @required this.title,
        this.fullWidth = true,
        this.loading = false,
        this.enabled = true,
        this.buttonType = ButtonType.blue_filled,
        this.upperCase = true,
        this.height = DEFAULT_HEIGHT,
        this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
        this.textStyle,
        this.margin = DEFAULT_MARGIN,
        this.borderWidth = DEFAULT_BORDER_WIDTH})
      : super(key: key);

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.fullWidth) return button();

    return Row(
      children: <Widget>[
        Expanded(flex: 1, child: Container()),
        button(),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Widget button() {
    Themes theme = App.theme;
    Color borderColor, backgroundColor, textColor;
    switch (widget.buttonType) {
      case ButtonType.blue_filled:
        borderColor = theme.colors.primary;
        backgroundColor = theme.colors.primary;
        textColor = Colors.white;
        break;
      case ButtonType.gray_filled:
        borderColor = Color(0xFFE1E1E1);
        backgroundColor = Color(0xFFE1E1E1);
        textColor = Colors.black;
        break;
      case ButtonType.orange_filled:
        borderColor = theme.colors.background1;
        backgroundColor = theme.colors.background1;
        textColor = Colors.white;
        break;
      case ButtonType.white_filled:
        borderColor = Color(0xAAEEE1E1);
        backgroundColor = theme.colors.background;
        textColor = Colors.black;
        break;
      case ButtonType.blue_border:
        borderColor = theme.colors.primary;
        backgroundColor = Colors.transparent;
        textColor = theme.colors.primary;
        break;
      case ButtonType.white_border:
        borderColor = Colors.white;
        backgroundColor = Colors.transparent;
        textColor = Colors.white;
        break;
      case ButtonType.red_filled:
        borderColor = theme.colors.error;
        backgroundColor = theme.colors.error;
        textColor = Colors.white;
        break;
      case ButtonType.transparent:
        borderColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = theme.colors.primary;
        break;
    }

    if (!canPress()) {
      textColor = theme.colors.text3;
      backgroundColor = theme.colors.disabled;
      borderColor = theme.colors.disabled;
    }

    TextStyle textStyle = widget.textStyle ?? theme.styles.button1.copyWith(color: textColor);

    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: widget.borderWidth),
          borderRadius: widget.borderRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: borderColor.withOpacity(0.5),
              blurRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
          color: backgroundColor),
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 35),
        onPressed: canPress() ? widget.onPressed : null,
        child: Center(
          child: widget.loading
              ? SpinKitDoubleBounce(color: theme.colors.primary, size: 25)
              : Text(
            widget.title,
            style: textStyle,
          ),
        ),
      ),
    );
  }

  canPress() {
    return widget.enabled && !widget.loading && widget.onPressed != null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gatabank/theme/themes.dart' as themes;
import '../config.dart';

const DEFAULT_HEIGHT = 70.0;
const DEFAULT_KEYBOARD_TYPE = TextInputType.emailAddress;

class InputWidget extends StatefulWidget {
  final String title;
  final bool isPwd;
  final TextStyle textStyle;
  final TextStyle titleStyle;
  final TextInputType keyboardType;
  final Function validator;
  final Function onSaved;
  final Widget appendChild;
  final Widget prefixWidget;
  final String hintText;
  final Function onChanged;
  final TextEditingController controller;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final autoFocus;
  final String initialValue;

  const InputWidget(
      {Key key,
        @required this.title,
        this.initialValue,
        this.prefixWidget,
        this.autoFocus = false,
        this.onChanged,
        this.maxLines = 1,
        this.isPwd = false,
        this.enabled = true,
        this.hintText,
        this.titleStyle,
        this.textStyle,
        this.keyboardType = DEFAULT_KEYBOARD_TYPE,
        this.validator,
        this.appendChild,
        @required this.onSaved,
        this.inputFormatters,
        this.controller})
      : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _isShowPwd;
  var _textController = TextEditingController();

  @override
  void initState() {
    _isShowPwd = false;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themes.Themes theme = App.theme;
    TextStyle textStyle =
        widget.textStyle ?? theme.styles.body1.copyWith(color: theme.colors.text1);
    TextStyle titleStyle =
        widget.titleStyle ?? theme.styles.subTitle1.copyWith(color: theme.colors.text9);
    Color borderColor = theme.colors.primary;

    return Container(
      height: DEFAULT_HEIGHT,
      child: Stack(
        children: <Widget>[
          TextFormField(
            initialValue: widget.initialValue,
            controller: widget.initialValue != null
                ? null
                : widget.controller == null ? _textController : widget.controller,
            key: Key(widget.title),
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            autofocus: widget.autoFocus,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onSaved: (value) => widget.onSaved(value.trim()),
            style: textStyle,
            maxLines: widget.maxLines,
            minLines: 1,
            obscureText: (widget.isPwd) ? ((_isShowPwd) ? false : true) : false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.fromLTRB(20, 15, 50, 15),
              border: InputBorder.none,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              prefix: widget.prefixWidget ??
                  Container(
                    height: 0,
                    width: 0,
                  ),
              labelText: widget.title,
              labelStyle: titleStyle,
              errorStyle: theme.styles.body4.copyWith(color: theme.colors.error),
            ),
            enabled: widget.enabled,
          ),
          widget.appendChild ??
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: DEFAULT_HEIGHT / 4, right: 15),
                child: _showPwd(),
              ),
        ],
      ),
    );
  }

  _showPwd() {
    if (widget.isPwd) {
      return InkWell(
          onTap: () {
            setState(() {
              _isShowPwd = !_isShowPwd;
            });
          },
          child: App.theme.getSvgPicture('eye${_isShowPwd ? '_off' : ''}'));
    }
    return Container();
  }
}

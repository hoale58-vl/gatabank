import 'package:flutter/material.dart';
import 'package:gatabank/config/config.dart';

const DEFAULT_POPUP_ICON = 'warning';

class PopupWidget extends StatefulWidget {
  final String icon;
  final String title;
  final Widget content;
  final List<Widget> actions;

  const PopupWidget(
      {Key key,
        this.icon = DEFAULT_POPUP_ICON,
        @required this.title,
        this.content,
        @required this.actions})
      : super(key: key);

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  _buildContent() {
    if (widget.content != null) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          widget.content,
          SizedBox(
            height: 30,
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            App.theme.getSvgPicture(
              widget.icon,
              width: 80,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 21, fontWeight: FontWeight.bold, color: App.theme.colors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            _buildContent(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.actions,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

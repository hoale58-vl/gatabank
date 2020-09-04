import 'package:flutter/material.dart';
import 'package:gatabank/config/config.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Widget leadingButton;
  final bool disableBackButton;

  @override
  final Size preferredSize;

  AppBarWidget(this.title,
      {Key key, this.actions, this.leadingButton, this.disableBackButton = false})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    var actions = widget.actions ?? List<Widget>();
    if (widget.leadingButton != null) {
      return AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: Theme.of(context).appBarTheme.elevation,
        bottomOpacity: .2,
        title: Text(
          widget.title,
          style: App.theme.styles.title3,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: actions,
        leading: widget.leadingButton,
      );
    }
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      elevation: Theme.of(context).appBarTheme.elevation,
      bottomOpacity: .2,
      title: Text(
        widget.title,
        style: App.theme.styles.title3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actions: actions,
    );
  }
}

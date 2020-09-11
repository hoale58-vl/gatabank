import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gatabank/config.dart';

class RowItem {
  final String icon;
  final String name;
  final Action action;
  final String value;
  final Widget trailing;
  final bool hasDivider, disableTrailing;
  final Color color, valueColor, backGroundColor;
  final EdgeInsetsGeometry padding;

  RowItem(this.icon, this.name,
      {this.action,
        this.value,
        this.trailing,
        this.hasDivider = true,
        this.color,
        this.backGroundColor,
        this.padding,
        this.disableTrailing = false,
        this.valueColor});

  Widget getWidget({BuildContext context, VoidCallback onTap}) {
    return InkWell(
      child: Container(
        color: this.backGroundColor,
        padding: padding ?? EdgeInsets.only(top: disableTrailing ? 20 : 15, left: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          (this.icon.isNotEmpty) ? App.theme.getSvgPicture(this.icon) : Container(),
          (this.icon.isNotEmpty) ? SizedBox(width: 15) : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(name,
                            style: App.theme.styles.body1
                                .copyWith(color: color ?? App.theme.colors.text1))),
                    _buildTrailing(context),
                  ],
                ),
                SizedBox(height: 20),
                Divider(
                    color: hasDivider ? App.theme.colors.divider : Colors.transparent,
                    height: 1,
                    thickness: 1),
              ],
            ),
          )
        ]),
      ),
      onTap: onTap,
    );
  }

  _buildTrailing(BuildContext context) {
    if (trailing != null)
      return Container(
        child: trailing,
        height: 25,
        padding: EdgeInsets.only(right: 15),
      );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        value == null || value.isEmpty
            ? Container()
            : Container(
            child: Text(value,
                style: App.theme.styles.subTitle2
                    .copyWith(color: valueColor ?? App.theme.colors.primary))),
        disableTrailing ? Container() : Icon(
          Icons.keyboard_arrow_right,
          size: 25.0,
          color: App.theme.colors.button1,
        ),
        SizedBox(width: 10)
      ],
    );
  }
}
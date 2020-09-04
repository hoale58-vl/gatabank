import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SubmitResultScreen extends StatelessWidget {
  _title() {
    return Container(
      child: Text(LocaleKeys.account_thank_you.tr(args: ['\n']),
          style: TextStyle(fontSize: 24, color: App.theme.colors.text1),
          textAlign: TextAlign.center),
      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
    );
  }

  _description() {
    return Container(
      child: Text(LocaleKeys.account_we_will_send_you_an_email.tr(),
          style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
          textAlign: TextAlign.center),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: App.theme.colors.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: Theme.of(context).appBarTheme.elevation,
        bottomOpacity: .2,
        title: Text(
          LocaleKeys.account_in_review.tr(),
          style: App.theme.styles.title3,
        ),
        leading: Container(),
      ),
      body: Column(
        children: <Widget>[
          _title(),
          _description(),
          Container(
            child: ButtonWidget(
              buttonType: ButtonType.blue_filled,
              title: LocaleKeys.account_continue.tr(),
              onPressed: () => Navigator.pop(context),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          )
        ],
      ),
    );
  }
}

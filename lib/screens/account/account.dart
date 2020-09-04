import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:gatabank/blocs/auth/auth_bloc.dart';
import 'package:gatabank/blocs/auth/auth_events.dart';
import 'package:gatabank/blocs/user/user_bloc.dart';
import 'package:gatabank/blocs/user/user_events.dart';
import 'package:gatabank/blocs/user/user_states.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/widgets/common/app_bar_widget.dart';
import 'package:gatabank/widgets/common/button_widget.dart';

class AccountScreen extends StatefulWidget {
  final bool isRegistering;
  final AuthBloc authBloc;

  AccountScreen({this.isRegistering = false, this.authBloc, Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User _user;
  UserBloc _userBloc;
  bool _isLoading = false;

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(UserGetProfile());
    super.initState();
  }

  Widget _buildItemList(BuildContext context) {
    List<Widget> itemList = [
      _title(),
      _description(),
      _rowItem(VerificationLevel.Email),
      _rowItem(VerificationLevel.Phone),
      SizedBox(height: 100),
      _doneButton(),
      _hint(),
    ];
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: itemList)),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(),
          ),
        )
      ],
    );
  }

  _doneButton() => Opacity(
      child: Container(
          child: ButtonWidget(
            title: LocaleKeys.account_done.tr(),
            onPressed: _goToHome,
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 60),
          )),
      opacity: widget.isRegistering && _user != null && _user.isInReview ? 1 : 0);

  _hint() => Opacity(
      child: Container(
        child: Text(LocaleKeys.account_once_you_verify_all_required.tr(),
            style: TextStyle(fontSize: 14, color: App.theme.colors.text1),
            textAlign: TextAlign.center),
        padding: EdgeInsets.symmetric(horizontal: 40),
      ),
      opacity: widget.isRegistering ? 1 : 0);

  _title() {
    return Container(
      child: Text(_user.verifiedStatus.getTitle(),
          style: TextStyle(fontSize: 24, color: App.theme.colors.text1),
          textAlign: TextAlign.center),
      padding: EdgeInsets.only(top: 20, left: 15, right: 15),
    );
  }

  _description() {
    return Container(
      child: Text(_user.verifiedStatus.getDescription(),
          style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
          textAlign: TextAlign.center),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          _isLoading = state is UserStateLoading;
          if (state is UserGetSuccess) {
            setState(() {
              _user = state.user;
            });
          }
        },
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: ModalProgressHUD(
                inAsyncCall: _isLoading,
                child: Scaffold(
                  backgroundColor: App.theme.colors.background,
                  appBar: AppBarWidget(
                    LocaleKeys.account_account.tr(),
                    actions: <Widget>[_skip()],
                  ),
                  body: _user == null ? Container() : _buildItemList(context),
                ))));
  }

  Future<bool> _onWillPop() {
    if (!widget.isRegistering) Navigator.of(context).pop(_user);
    return Future.value(false);
  }

  _skip() => widget.isRegistering && _user != null && !_user.isInReview
      ? Container(
    padding: EdgeInsets.only(right: 15),
    alignment: Alignment.center,
    child: GestureDetector(
        onTap: _goToHome,
        child: Text(LocaleKeys.account_skip.tr(),
            style: App.theme.styles.body5.copyWith(color: Colors.white))),
  )
      : Container();

  _goToHome() {
    if (widget.isRegistering && _user != null && !_user.isInReview) {
      widget.authBloc.add(AppStarted());
      Navigator.pushNamedAndRemoveUntil(
          context, ScreenRouter.ROOT, (Route<dynamic> route) => false);
    }
  }

  _rowItem(VerificationLevel verifiedLevel) {
    VerificationStatus verifiedStatus = _user.getVerifiedStatus(verifiedLevel);
    String description = _getDescription(verifiedLevel);
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 15, left: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          App.theme.getSvgPicture(verifiedLevel.icon),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(verifiedLevel.getName(),
                              style: App.theme.styles.body5.copyWith(color: App.theme.colors.text1)),
                          description.isEmpty
                              ? Container()
                              : Text(description,
                              style: App.theme.styles.subTitle2
                                  .copyWith(color: App.theme.colors.text1)),
                        ])),
                    Text(verifiedStatus.getName(),
                        style: App.theme.styles.body1
                            .copyWith(color: VerificationStatus.getColor(verifiedStatus))),
                    Opacity(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: App.theme.colors.button1,
                          size: 25.0,
                        ),
                        opacity: verifiedStatus.clickable ? 1 : 0),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(color: App.theme.colors.divider, height: 1, thickness: 1),
              ],
            ),
          )
        ]),
      ),
      onTap: () => _handleClick(verifiedLevel),
    );
  }

  _handleClick(VerificationLevel verifiedLevel) async {
    VerificationStatus verifiedStatus = _user.getVerifiedStatus(verifiedLevel);
    if (!verifiedStatus.clickable) return;
    switch (verifiedLevel) {
      case VerificationLevel.Phone:
        await goToInputPhoneScreen();
        break;
      case VerificationLevel.Email:
        await goToVerificationScreen(verifiedLevel, email: _user.email);
        break;
    }
    if (verifiedStatus != VerificationStatus.VerifiedFailed)
      _userBloc.add(UserGetProfile()); // refresh user data after update
  }

  _getDescription(VerificationLevel verifiedLevel) {
    switch (verifiedLevel) {
      case VerificationLevel.Email:
        return _user.email;
      case VerificationLevel.Phone:
        return _user.fullPhoneNumber ?? '';
    }
  }

  goToInputPhoneScreen() async {
    await Navigator.pushNamed(context, ScreenRouter.INPUT_PHONE, arguments: {
      ScreenRouter.AGR_PHONE: _user.phone,
      ScreenRouter.AGR_COUNTRY: _user.countryCode
    });
  }

  goToVerificationScreen(VerificationLevel verifiedLevel, {String email}) async {
    await Navigator.pushNamed(context, ScreenRouter.VERIFICATION_CODE, arguments: {
      ScreenRouter.AGR_VERIFICATION_TYPE: verifiedLevel.verifiedType,
      ScreenRouter.AGR_VERIFICATION_EMAIL: email,
    });
  }
}

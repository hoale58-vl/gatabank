import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/blocs/forgot_pwd/bloc.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/validators/email_validator.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/account/verification_code.dart';
import 'package:gatabank/widgets/common/app_bar_widget.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/widgets/common/input/input_widget.dart';

class ForgotPwdScreen extends StatefulWidget {
  @override
  _ForgotPwdScreenState createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgotPwdBloc _forgotPwdBloc;

  String _email;

  Widget _buildButton() {
    return BlocBuilder<ForgotPwdBloc, ForgotPwdState>(
      bloc: _forgotPwdBloc,
      builder: (context, state) {
        return (state == ForgotPwdLoading())
            ? CircularProgressIndicator(key: Key("ok"))
            : Container(
          child: ButtonWidget(
            key: Key('BtnNext'),
            onPressed: _handleNextClicked,
            title: LocaleKeys.auth_submit.tr(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30),
        );
      },
    );
  }

  Widget _buildBottom() {
    return BlocBuilder<ForgotPwdBloc, ForgotPwdState>(
      bloc: _forgotPwdBloc,
      builder: (context, state) {
        if (state is ForgotPwdStatus) {
          if (state.value == false) {
            return Column(
              children: <Widget>[
                Text(
                  LocaleKeys.error_email_you_entered_has_not.tr(),
                  textAlign: TextAlign.center,
                  style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.auth_register.tr(),
                      style: App.theme.styles.button1.copyWith(color: App.theme.colors.primary),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(ScreenRouter.REGISTER);
                  },
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              App.theme.getSvgPicture('forgot_pwd_lock'),
              SizedBox(
                height: 50,
              ),
              Text(
                LocaleKeys.auth_please_enter_the_email_you_used_to.tr(),
                textAlign: TextAlign.center,
                style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
              ),
              Container(
                padding: EdgeInsets.only(top: 35, bottom: 10, left: 30, right: 30),
                child: InputWidget(
                  title: LocaleKeys.auth_email.tr(),
                  onSaved: (value) => _email = value,
                  validator: EmailFieldValidator.validate,
                ),
              ),
              _buildButton(),
              SizedBox(
                height: 90,
              ),
              _buildBottom()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _forgotPwdBloc = BlocProvider.of<ForgotPwdBloc>(context);
    return BlocListener<ForgotPwdBloc, ForgotPwdState>(
      bloc: _forgotPwdBloc,
      listener: (context, state) {
        if (state is ForgotPwdStatus) {
          if (state.value) {
            Navigator.pushNamed(context, ScreenRouter.VERIFICATION_CODE, arguments: {
              ScreenRouter.AGR_VERIFICATION_EMAIL: _email,
              ScreenRouter.AGR_VERIFICATION_TYPE: ValidationType.ForgotPassword
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: App.theme.colors.background,
        appBar: AppBarWidget(LocaleKeys.auth_forgot_password.tr()),
        body: _buildContent(),
      ),
    );
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _handleNextClicked() {
    if (_validateAndSave()) {
      _forgotPwdBloc.add(ForgotPwdCheckEmail(email: _email));
    }
  }
}

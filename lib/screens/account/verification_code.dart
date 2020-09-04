import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/blocs/user/user_bloc.dart';
import 'package:gatabank/blocs/user/user_events.dart';
import 'package:gatabank/blocs/user/user_states.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/theme/themes.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/widgets/common/app_bar_widget.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/widgets/common/input/pin_code_field.dart';
import 'package:gatabank/widgets/common/rich_text_widget.dart';

class ValidationType {
  final id, value, length;

  const ValidationType._internal(this.id, this.length, {this.value});

  toString() => 'Enum.$id';

  getName() {
    if (id == ForgotPassword.id)
      return LocaleKeys.verification_code_forgot_password.tr();
    else if (id == VerificationEmail.id)
      return LocaleKeys.verification_code_authentication_code.tr();
    else
      return LocaleKeys.verification_code_authentication_code.tr();
  }

  getTitle({String highlightText}) {
    if (id == ForgotPassword.id)
      return LocaleKeys.verification_code_an_email_has_been_sent_with_an.tr();
    else if (id == VerificationEmail.id)
      return LocaleKeys.verification_code_we_sent_an_email_with.tr(args: [highlightText]);
    else
      return LocaleKeys.verification_code_an_authentication_code_is_sent.tr(args: [highlightText]);
  }

  getButton() {
    if (id == ForgotPassword.id)
      return LocaleKeys.verification_code_open_mail_app.tr();
    else if (id == VerificationEmail.id)
      return LocaleKeys.verification_code_open_mail_app.tr();
    else
      return LocaleKeys.verification_code_open_message_app.tr();
  }

  static const ForgotPassword = const ValidationType._internal(0, 4);
  static const VerificationEmail = const ValidationType._internal(1, 4, value: 1);
  static const VerificationPhone = const ValidationType._internal(2, 6, value: 2);
}

class VerificationCodeScreen extends StatefulWidget {
  final String recaptchaToken;
  final String phone;
  final String countryCode;
  final String email;
  final ValidationType verifiedType;
  final bool isRegistering;

  const VerificationCodeScreen(
      {Key key,
        this.recaptchaToken,
        this.phone,
        this.countryCode,
        this.email,
        @required this.verifiedType,
        this.isRegistering = false})
      : super(key: key);

  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}

const int RESEND_INTERVAL_IN_SECOND = 120;

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController(text: "");

  UserBloc _userBloc;
  ValidationType _verifiedType;
  String _verificationCode;
  String _firebaseSID;

  @override
  void initState() {
    _verifiedType = widget.verifiedType;
    _userBloc = BlocProvider.of<UserBloc>(context);
    _sendVerificationCode();
    super.initState();
  }

  Widget _buildPinCode() {
    return BlocBuilder<UserBloc, UserState>(
        bloc: _userBloc,
        builder: (ctx, state) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                LocaleKeys.verification_code_enter_authentication_code.tr(),
                textAlign: TextAlign.center,
                style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
              ),
              SizedBox(
                height: 15,
              ),
              PinCodeTextField(
                key: Key("pinCodeKey"),
                autofocus: false,
                controller: controller,
                hideCharacter: false,
                highlight: true,
                highlightColor: App.theme.colors.primary,
                defaultBorderColor: App.theme.colors.divider,
                hasTextBorderColor: App.theme.colors.primary,
                pinBoxWidth: _calculateWidthOfPinCode(_verifiedType.length),
                pinBoxHeight: _calculateWidthOfPinCode(_verifiedType.length),
                maxLength: _verifiedType.length,
                hasError: state is UserStateFailed,
                onTextChanged: (text) {},
                onDone: (text) {
                  _verificationCode = text;
                },
                wrapAlignment: WrapAlignment.spaceAround,
                pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                pinTextStyle: TextStyle(
                    fontSize: (_verifiedType.length == ValidationType.VerificationPhone.length)
                        ? 28.0
                        : 38.0,
                    fontWeight: FontWeight.bold,
                    color: App.theme.colors.text2),
                pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                pinBoxRadius: 12,
                pinBoxBorderWidth: 2,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
                highlightAnimationBeginColor: Colors.black,
                highlightAnimationEndColor: Colors.white12,
                keyboardType: TextInputType.number,
              ),
            ],
          );
        });
  }

  Widget _buildBottom() {
    return BlocBuilder<UserBloc, UserState>(
      bloc: _userBloc,
      builder: (context, state) {
        return Column(
          children: <Widget>[
            Text(
              LocaleKeys.verification_code_the_authentication_code_will.tr(),
              textAlign: TextAlign.center,
              style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
            ),
            SizedBox(
              height: 8,
            ),
            _enableResendButton
                ? _resendButton()
                : Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: _resendButton(),
            )
          ],
        );
      },
    );
  }

  _resendButton() => Opacity(
    child: InkWell(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            LocaleKeys.verification_code_resend_new_code.tr(),
            style: App.theme.styles.button1.copyWith(color: App.theme.colors.primary),
          ),
        ),
        onTap: () {
          if (!_enableResendButton) return;
          if (widget.verifiedType == ValidationType.VerificationPhone) {
            Navigator.pop(context);
            return;
          }
          _sendVerificationCode();
        }),
    opacity: _enableResendButton ? 1 : 0.5,
  );

  Timer _resendTimer;
  int _timerCounter;
  bool _enableResendButton = false;

  _sendVerificationCode() {
    startTimer();
    _userBloc.add(UserSendVerification(_verifiedType,
        email: widget.email,
        phone: widget.phone,
        countryCode: widget.countryCode,
        recaptchaToken: widget.recaptchaToken));
  }

  void startTimer() {
    _timerCounter = RESEND_INTERVAL_IN_SECOND;
    const oneSec = const Duration(seconds: 1);
    setState(() {
      _enableResendButton = false;
    });
    _resendTimer = new Timer.periodic(oneSec, (Timer timer) {
      if (_timerCounter < 1) {
        timer.cancel();
        setState(() {
          _enableResendButton = true;
        });
      } else {
        _timerCounter--;
      }
    });
  }

  @override
  void dispose() {
    _resendTimer.cancel();
    super.dispose();
  }

  Widget _buildButton() {
    return BlocBuilder<UserBloc, UserState>(
        bloc: _userBloc,
        builder: (ctx, state) {
          return (state == UserStateLoading())
              ? CircularProgressIndicator()
              : Container(
            child: ButtonWidget(
              key: Key('BtnNext'),
              onPressed: _handleNextClicked,
              title: LocaleKeys.verification_code_verify.tr(),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50),
          );
        });
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: _titleField(),
                padding: EdgeInsets.symmetric(horizontal: 30),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _verifiedType.getButton(),
                    style: App.theme.styles.button1.copyWith(color: App.theme.colors.primary),
                  ),
                ),
                onTap: () => print(''),
              ),
              SizedBox(
                height: 80,
              ),
              _buildPinCode(),
              SizedBox(
                height: 15,
              ),
              _buildButton(),
              SizedBox(
                height: 120,
              ),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  _titleField() {
    if (_verifiedType == ValidationType.ForgotPassword) {
      return Text(
        _verifiedType.getTitle(),
        textAlign: TextAlign.center,
        style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
      );
    }

    var highlightText = (_verifiedType == ValidationType.VerificationEmail)
        ? widget.email
        : widget.countryCode + widget.phone;
    var style = App.theme.styles.body1.copyWith(color: App.theme.colors.text1);
    return RichTextWidget(
        text: (_verifiedType.getTitle(highlightText:highlightText)),
        highlightText: highlightText,
        textAlign: TextAlign.center,
        textStyle: style,
        highlightTextStyle: style.copyWith(fontWeight: SemiBold));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserCheckVerificationSuccess) {
          if (_verifiedType == ValidationType.ForgotPassword) {
            Navigator.pushNamed(context, ScreenRouter.RESET_PWD, arguments: {
              'email': widget.email,
              'authenticationCode': _verificationCode,
            });
          } else {
            if (widget.isRegistering) {
              Navigator.pushNamedAndRemoveUntil(
                  context, ScreenRouter.ACCOUNT_SCREEN, (Route<dynamic> route) => false,
                  arguments: {ScreenRouter.AGR_IS_REGISTERING: true});
            } else {
              Navigator.popUntil(context, ModalRoute.withName(ScreenRouter.ACCOUNT_SCREEN));
            }
          }
        } else if (state is UserStateFailed) {
          _handleFailed(state.error);
        } else if (state is UserSendVerificationSuccess) {
          _firebaseSID = state.firebaseSID;
        }
      },
      child: Scaffold(
        backgroundColor: App.theme.colors.background,
        appBar: AppBarWidget(_verifiedType.getName()),
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
      _userBloc.add(UserCheckVerification(_verifiedType, _verificationCode,
          email: widget.email, firebaseSID: _firebaseSID));
    }
  }

  static const PADDING_PIN_CODE = 4;
  static const PADDING = 30;

  _calculateWidthOfPinCode(int length) {
    double width = MediaQuery.of(context).size.width;
    width -= (length * 2 * PADDING_PIN_CODE);
    width -= PADDING * 2;
    return width / length;
  }

  void _handleFailed(String error) {
    if (error.contains(LocaleKeys.error_please_input_verification_code.tr()))
      return;
    else if (error.contains(LocaleKeys.error_invalid_code.tr()))
      utils.errorToast(LocaleKeys.error_invalid_code.tr());
    else
      utils.errorToast(error);
  }
}

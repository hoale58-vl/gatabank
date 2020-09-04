import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatabank/blocs/auth/auth_bloc.dart';
import 'package:gatabank/blocs/register/register_bloc.dart';
import 'package:gatabank/blocs/register/register_events.dart';
import 'package:gatabank/blocs/register/register_states.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/data/validators/email_validator.dart';
import 'package:gatabank/data/validators/password_validator.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/widgets/common/input/input_widget.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';


class RegisterScreen extends StatefulWidget {
  final AuthBloc authBloc;

  RegisterScreen(this.authBloc);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegisterBloc _registerBloc;
  TapGestureRecognizer _tapTermOfUseGestureRecognizer, _tapPrivacyPolicyGestureRecognizer;

  String _email, _password, _confirmPassword, _referralCode;
  bool _isChecked;

  @override
  void initState() {
    _isChecked = false;
    super.initState();

    _tapTermOfUseGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
      };

    _tapPrivacyPolicyGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
      };
  }

  Widget _buildContent(RegisterState state) {
    if (state is RegisterSuccess) {
      return Container();
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              App.theme.getSvgPicture('myTwallet', height: 185),
              SizedBox(
                height: 30,
              ),
              InputWidget(
                title: LocaleKeys.auth_email.tr(),
                onSaved: (value) => _email = value,
                validator: EmailFieldValidator.validate,
              ),
              SizedBox(
                height: 10,
              ),
              InputWidget(
                title: LocaleKeys.auth_password.tr(),
                isPwd: true,
                onSaved: (value) => _password = value,
                validator: PasswordFieldValidator.validate,
              ),
              SizedBox(
                height: 10,
              ),
              InputWidget(
                title: LocaleKeys.auth_confirm_password.tr(),
                isPwd: true,
                onSaved: (value) => _confirmPassword = value,
                validator: PasswordFieldValidator.validate,
              ),
              SizedBox(
                height: 10,
              ),
              InputWidget(
                title: LocaleKeys.auth_referral_code.tr(),
                initialValue: App.referralCode ?? '',
                onSaved: (value) => _referralCode = value,
              ),
              _tac(),
              SizedBox(
                height: 15,
              ),
              (state == RegisterLoading())
                  ? CircularProgressIndicator()
                  : ButtonWidget(
                key: Key('BtnRegister'),
                onPressed: _handleSignUp,
                title: LocaleKeys.auth_register.tr(),
              ),
              SizedBox(
                height: 20,
              ),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  _tac() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
          flex: 1,
          child: Align(
            child: Container(
              width: 15,
              height: 15,
              child: Transform.scale(
                  scale: 0.7,
                  child: CircularCheckBox(
                    value: _isChecked,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool isChecked) {
                      setState(() {
                        _isChecked = isChecked;
                      });
                    },
                  )),
            ),
            alignment: Alignment.topCenter,
          )),
      Expanded(
        flex: 9,
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: RichText(
            text: TextSpan(
              text: LocaleKeys.auth_i_understand_and_agree_to_the.tr(),
              style:
              App.theme.styles.body1.copyWith(fontSize: 13, color: App.theme.colors.text1),
              children: <TextSpan>[
                TextSpan(
                  text: LocaleKeys.auth_terms_of_use.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).buttonColor,
                      fontSize: 13),
                  recognizer: _tapTermOfUseGestureRecognizer,
                ),
                TextSpan(
                  text: LocaleKeys.auth_and.tr(),
                  style: App.theme.styles.body1.copyWith(fontSize: 13),
                ),
                TextSpan(
                  text: LocaleKeys.auth_privacy_policy.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).buttonColor,
                      fontSize: 13),
                  recognizer: _tapPrivacyPolicyGestureRecognizer,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildBottom() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        child: RichText(
          text: TextSpan(
            text: LocaleKeys.auth_have_account_already.tr(),
            style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
            children: <TextSpan>[
              TextSpan(
                text: LocaleKeys.auth_login.tr(),
                style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        } else if (state is RegisterSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, ScreenRouter.VERIFICATION_CODE, (Route<dynamic> route) => false,
              arguments: {
                ScreenRouter.AGR_VERIFICATION_EMAIL: _email,
                ScreenRouter.AGR_VERIFICATION_TYPE: VerificationLevel.Email.verifiedType,
                ScreenRouter.AGR_IS_REGISTERING: true
              });
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: null,
            body: Container(
              color: Theme.of(context).backgroundColor,
              child: _buildContent(state),
            ),
          );
        },
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

  _handleSignUp() async {
    if (!_validateAndSave()) return;
    _registerBloc.add(RegisterButtonPressed(
        email: _email,
        password: _password,
        confirmPassword: _confirmPassword,
        isCheckTermAndAgreement: _isChecked,
        referralCode: _referralCode));
  }
}

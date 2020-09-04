import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gatabank/blocs/login/login_bloc.dart';
import 'package:gatabank/blocs/login/login_events.dart';
import 'package:gatabank/blocs/login/login_states.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/validators/email_validator.dart';
import 'package:gatabank/data/validators/password_validator.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/widgets/common/input/input_widget.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildContent(LoginState state) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              App.theme.getSvgPicture('myTwallet', height: 185),
              SizedBox(
                height: 50,
              ),
              InputWidget(
                title: LocaleKeys.auth_email.tr(),
                onSaved: (value) => _email = value,
                validator: EmailFieldValidator.validate,
              ),
              SizedBox(
                height: 15,
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
              _buildForgotPwd(),
              SizedBox(
                height: 20,
              ),
              (state == LoginLoading())
                  ? CircularProgressIndicator()
                  : ButtonWidget(
                key: Key('BtnLogin'),
                onPressed: _handleLogin,
                title: LocaleKeys.auth_login.tr(),
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

  Widget _buildForgotPwd() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            LocaleKeys.auth_forgot_password.tr(),
            style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary),
          ),
        ),
        onTap: _handleForgotPwdClicked,
      ),
    );
  }

  Widget _buildBottom() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        child: RichText(
          text: TextSpan(
            text: LocaleKeys.auth_no_account_yet.tr(),
            style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
            children: <TextSpan>[
              TextSpan(
                  text: LocaleKeys.auth_register.tr(),
                  style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary)),
            ],
          ),
        ),
        onTap: _handleSignUp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        bloc: _loginBloc,
        builder: (context, state) {
          if (state is LoginSuccess) {
            return Scaffold();
          }

          return Scaffold(
            appBar: null,
            body: Container(
              color: App.theme.colors.background,
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

  void _handleLogin() {
    if (_validateAndSave()) {
      _loginBloc.add(LoginButtonPressed(
        email: _email,
        password: _password,
      ));
    }
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, ScreenRouter.REGISTER);
  }

  void _handleForgotPwdClicked() {
    Navigator.pushNamed(context, ScreenRouter.FORGOT_PWD);
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/blocs/forgot_pwd/bloc.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/data/validators/password_validator.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/widgets/common/app_bar_widget.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:gatabank/widgets/common/input/input_widget.dart';


class ResetPwdScreen extends StatefulWidget {
  final String email;
  final String authenticationCode;

  const ResetPwdScreen({Key key, this.email, this.authenticationCode}) : super(key: key);

  @override
  _ResetPwdScreenState createState() => _ResetPwdScreenState();
}

class _ResetPwdScreenState extends State<ResetPwdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgotPwdBloc _forgotPwdBloc;
  String _password, _confirmPassword;

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputWidget(
              title: LocaleKeys.auth_password.tr(),
              isPwd: true,
              onSaved: (value) => _password = value,
              validator: PasswordFieldValidator.validate,
            ),
            SizedBox(
              height: 15,
            ),
            InputWidget(
              title: LocaleKeys.auth_confirm_password.tr(),
              isPwd: true,
              onSaved: (value) => _confirmPassword = value,
              validator: PasswordFieldValidator.validate,
            ),
            SizedBox(
              height: 15,
            ),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return BlocBuilder<ForgotPwdBloc, ForgotPwdState>(
        bloc: _forgotPwdBloc,
        builder: (ctx, state) {
          return (state == ForgotPwdLoading())
              ? CircularProgressIndicator()
              : ButtonWidget(
            key: Key('Save'),
            onPressed: _handleSaveClicked,
            title: LocaleKeys.auth_save.tr(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _forgotPwdBloc = BlocProvider.of<ForgotPwdBloc>(context);
    return BlocListener<ForgotPwdBloc, ForgotPwdState>(
      listener: (context, state) {
        if (state is ForgotPwdResetStatus) {
          if (state.value) {
            utils.toast(LocaleKeys.auth_your_password_has_been_changed.tr());

            Navigator.of(context).popUntil((route) {
              return route.settings.name == "/";
            });
          } else {
            utils.errorToast(LocaleKeys.error_please_double_check_your_password.tr());
          }
        }

        if (state is ForgotPwdFailed) {
          utils.errorToast(state.error);
        }
      },
      child: Scaffold(
        backgroundColor: App.theme.colors.background,
        appBar: AppBarWidget(LocaleKeys.auth_reset_password.tr()),
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

  _handleSaveClicked() {
    if (_validateAndSave()) {
      _forgotPwdBloc.add(ForgotPwdResetNewOne(
          email: widget.email,
          authenticationCode: widget.authenticationCode,
          newPassword: _password,
          confirmNewPassword: _confirmPassword));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/validators/phone_validator.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/input_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_bloc.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone;

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
              App.theme.getSvgPicture('logo', height: 185),
              SizedBox(
                height: 50,
              ),
              InputWidget(
                title: "Số điện thoại (+84)",
                onSaved: (value) => _phone = value,
                validator: PhoneValidator.validate,
              ),
              SizedBox(
                height: 15,
              ),
              _buildBottom(),
              SizedBox(
                height: 20,
              ),
              (state == LoginLoading())
                  ? CircularProgressIndicator()
                  : ButtonWidget(
                key: Key('BtnLogin'),
                onPressed: _handleLogin,
                title: "Đăng nhập",
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        child: RichText(
          text: TextSpan(
            text: "Khi đăng nhập, bạn đã đồng ý với ",
            style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
            children: <TextSpan>[
              TextSpan(
                  text: "Điều khoản dịch vụ ",
                  style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary),
                  children: <TextSpan>[
                    TextSpan(
                        text: "và ",
                        style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Chính sách bảo mật",
                              style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary)
                          ),
                        ],
                    ),
                  ],
              ),
            ],
          ),
        ),
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
              msg: "Đăng nhập không thành công",
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
        phone: _phone
      ));
    }
  }
}

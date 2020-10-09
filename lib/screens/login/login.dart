import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/validators/phone_validator.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/input_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../screen_router.dart';
import 'login_cubit.dart';
import 'login_states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phone;
  String _otp;
  LoginCubit _loginCubit;

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
          child: state is LoginSendingOtp? _buildOtpForm(state) : _buildPhoneForm(state)
        ),
      ),
    );
  }

  Widget _buildPhoneForm(LoginState state){
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/logo.png",
          width: 185,
          height: 185,
        ),
        SizedBox(
          height: 50,
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            child: RichText(
              text: TextSpan(
                text: "Việt Nam (+84)",
                style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        InputWidget(
          title: "Số điện thoại",
          onSaved: (value) => _phone = value,
          validator: (value) => PhoneValidator.validate(value),
        ),
        SizedBox(
          height: 15,
        ),
        Align(
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
        ),
        SizedBox(
          height: 20,
        ),
        (state == LoginLoading())
            ? CircularProgressIndicator()
            : ButtonWidget(
          key: Key('BtnSendOtp'),
          onPressed: _handleSendOtp,
          title: "Đăng nhập",
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildOtpForm(LoginSendingOtp state) {
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/logo.png",
          width: 185,
          height: 185,
        ),
        SizedBox(
          height: 50,
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            child: RichText(
              text: TextSpan(
                text: "Bạn vui lòng nhập mã OTP vừa gửi qua số điện thoại ${state.phone}",
                style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        InputWidget(
            title: "Mã OTP",
            onSaved: (value) => _otp = value,
            initialValue: "",
            validator: (value) {
              if (value.isEmpty) {
                return 'Vui lòng nhập mã OTP';
              }
              return null;
            }
        ),
        SizedBox(
          height: 35,
        ),
        (state == LoginLoading())
            ? CircularProgressIndicator()
            : ButtonWidget(
          key: Key('BtnLogin'),
          onPressed: _handleLogin,
          title: "Xác nhận",
        ),
        SizedBox(
          height: 20,
        ),
        (state == LoginLoading())
            ? CircularProgressIndicator()
            : ButtonWidget(
          key: Key('BtnResend'),
          onPressed: _handleSendOtp,
          title: "Gửi lại OTP",
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _loginCubit = BlocProvider.of<LoginCubit>(context);

    return BlocListener<LoginCubit, LoginState>(
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
        if (state is LoginSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              ScreenRouter.ROOT, (route) => false);
        }

      },
      child: BlocBuilder<LoginCubit, LoginState>(
        cubit: _loginCubit,
        builder: (context, state) {
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
      _loginCubit.login(
        _phone,
        _otp
      );
    }
  }

  void _handleSendOtp() {
    if (_validateAndSave()) {
      _loginCubit.sendOtp(
          _phone
      );
    }
  }
}

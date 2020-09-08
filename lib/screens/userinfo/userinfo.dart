import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/validators/string_validator.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/input_widget.dart';
import 'package:gatabank/widgets/popup_widget.dart';
import 'package:gatabank/widgets/row_item.dart';

import '../../config.dart';
import 'userinfo_bloc.dart';
import 'userinfo_states.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen();

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoScreen>  {
  UserInfoCubit _userInfoCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _income;
  int _loanExpected;
  int _loanTerm;
  String _address;
  String _salaryReceiveMethod;

  @override
  Widget build(BuildContext context) {
    _userInfoCubit = BlocProvider.of<UserInfoCubit>(context);

    return BlocListener<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
      },
      child: BlocBuilder<UserInfoCubit, UserInfoState>(
        cubit: _userInfoCubit,
        builder: (context, state) {
          if (state is UpdateUserSuccess) {
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

  Widget _buildContent(UserInfoState state) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
            key: _formKey,
            child: _buildUserInfoScreen(state)
        ),
      ),
    );
  }

  Widget _buildUserInfoScreen(UserInfoState state) {
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/user_info.png",
          fit: BoxFit.fitWidth
        ),
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "So sánh, chọn lựa\nCách so sánh công bằng nhất",
                style: App.theme.styles.body6.copyWith(color: App.theme.colors.text1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Thu thập hằng\n tháng của tôi là", value: _income ?? '').getWidget(
          onTap: () => {
            _handleInputUserInfo(
              title: "Thu nhập hằng tháng",
              onSaved: (value) => _income = value != null ? int.parse(value, onError: _income = null) : null,
              onSubmit: () => Intent.doNothing
            )
          }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi muốn vay", value: _loanExpected ?? '').getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Kì hạn vay", value: _loanTerm ?? '').getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi sống ở", value: _address ?? '').getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi nhận lương bằng", value: _salaryReceiveMethod ?? '').getWidget(),
        SizedBox(
          height: 25,
        ),
        Container (
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Column(
              children: <Widget>[
                (state == UserInfoLoading())
                    ? CircularProgressIndicator()
                    : ButtonWidget(
                  key: Key('BtnConfirm'),
                  onPressed: _handleConfirm,
                  title: "Xem kết quả",
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                  key: Key('BtnReset'),
                  onPressed: _handleResetForm,
                  title: "Bắt đầu lại",
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Bằng cách bấm vào nút ",
                        style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                        children: <TextSpan>[
                          TextSpan(
                            text: "\"Xem kết quả\", ",
                            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
                            children: <TextSpan>[
                              TextSpan(
                                text: "tôi đồng ý với ",
                                style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "các điều khoản và chính sách bảo mật ",
                                    style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "của ",
                                        style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Gatabank",
                                              style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1)
                                          ),
                                        ],
                                      ),
                                    ],
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
              ]
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
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

  _handleResetForm() {
    setState(() {
      _income = null;
      _loanExpected = null;
      _loanTerm = null;
      _address = null;
      _salaryReceiveMethod = null;
    });
  }

  _handleConfirm() {
    if (_validateAndSave()) {
      _userInfoCubit.submitData(
          income: _income,
          loanExpected: _loanExpected,
          loanTerm: _loanTerm,
          address: _address,
          salaryReceiveMethod: _salaryReceiveMethod
      );
    }
  }

  _handleInputUserInfo({@required String title, @required Function(String) onSaved, @required VoidCallback onSubmit}) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),
            child: PopupWidget(
              icon: '',
              title: title,
              content: InputWidget(
                title: title,
                onSaved: (value) => onSaved(value),
                validator: (value) => StringValidator.notEmpty(value),
              ),
              actions: <Widget>[
                ButtonWidget(
                  title: 'Quay lại',
                  onPressed: () {
                    onSaved(null);
                    Navigator.pop(context);
                  },
                  buttonType: ButtonType.blue_border,
                ),
                SizedBox(
                  width: 25,
                ),
                ButtonWidget(
                  title: 'Xác nhận',
                  onPressed: () {
                    onSubmit();
                    Navigator.pop(context);
                  },
                  buttonType: ButtonType.red_filled,
                )
              ],
            ),
          );
        });
      }
}
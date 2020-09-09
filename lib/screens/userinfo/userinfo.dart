import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/utils.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/input_widget.dart';
import 'package:gatabank/widgets/popup_widget.dart';
import 'package:gatabank/widgets/row_item.dart';

import '../../config.dart';
import 'userinfo_bloc.dart';
import 'userinfo_states.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoScreen>  {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _income;
  int _loanExpected;
  int _loanTerm;
  String _address;
  String _salaryReceiveMethod;
  UserInfoCubit _userInfoCubit;

  bool get submitBtnEnabled => _income != null && _loanExpected != null && _loanTerm != null && _address != null && _salaryReceiveMethod != null;

  TextEditingController incomeController = TextEditingController();
  TextEditingController loanExpectedController = TextEditingController();
  TextEditingController loanTermController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController salaryReceiveMethodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userInfoCubit = BlocProvider.of<UserInfoCubit>(context);

    return BlocListener<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        if (state is UpdateIncome) {
          _income = state.income;
        } else if (state is UpdateLoanExpected) {
          _loanExpected = state.loanExpected;
        } else if (state is UpdateLoanTerm) {
          _loanTerm = state.loanTerm;
        } else if (state is UpdateAddress) {
          _address = state.address;
        } else if (state is UpdateSalaryReceiveMethod) {
          _salaryReceiveMethod = state.salaryReceiveMethod;
        } else if (state is ShowError){
          Utils.errorToast(state.errorMsg);
        }
      },
      child: BlocBuilder(
        cubit: _userInfoCubit,
        builder: (context, state) {
          if (state is UpdateUserSuccess) {
            Navigator.pushNamed(context, ScreenRouter.ROOT);
          }

          return Scaffold(
            appBar: null,
            body: Container(
              color: App.theme.colors.background,
              child: _buildContent(state),
            ),
          );
        },
      )
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
        RowItem('', "Thu thập hằng\n tháng của tôi là", value: _income != null ? _income.toString() : '').getWidget(
          onTap: () => {
            _handleInputUserInfo(
              child: InputWidget(
                  controller: incomeController,
                  title: 'Thu nhập hằng tháng',
                  onSaved: (value) => _income = value,
              ),
              onSubmit: () => _userInfoCubit.updateIncome(incomeController.text)
            )
          }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi muốn vay", value: _loanExpected != null ? _loanExpected.toString() : '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: InputWidget(
                    controller: loanExpectedController,
                    title: 'Số tiền muốn vay',
                    onSaved: (value) => _loanExpected = value,
                  ),
                  onSubmit: () => _userInfoCubit.updateLoanExpected(loanExpectedController.text)
              )
            }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Kì hạn vay", value: _loanTerm != null ? _loanTerm.toString() : '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: InputWidget(
                    controller: loanTermController,
                    title: 'Kì hạn vay',
                    onSaved: (value) => _loanTerm = value,
                  ),
                  onSubmit: () => _userInfoCubit.updateLoanTerm(loanTermController.text)
              )
            }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi sống ở", value: _address ?? '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: InputWidget(
                    controller: addressController,
                    title: 'Địa chỉ',
                    onSaved: (value) => _address = value,
                  ),
                  onSubmit: () => _userInfoCubit.updateAddress(addressController.text)
              )
            }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi nhận lương bằng", value: _salaryReceiveMethod ?? '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: InputWidget(
                    controller: salaryReceiveMethodController,
                    title: 'Phương thức nhận lương',
                    onSaved: (value) => _salaryReceiveMethod = value,
                  ),
                  onSubmit: () => _userInfoCubit.updateSalaryReceiveMethod(salaryReceiveMethodController.text)
              )
            }
        ),
        SizedBox(
          height: 25,
        ),
        Container (
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Column(
              children: <Widget>[
                ButtonWidget(
                  key: Key('BtnConfirm'),
                  onPressed: _handleConfirm,
                  title: "Xem kết quả",
                  enabled: submitBtnEnabled,
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

  _handleInputUserInfo({@required VoidCallback onSubmit, @required InputWidget child}) async {
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
              title: '',
              content: child,
              actions: <Widget>[
                ButtonWidget(
                  title: 'Quay lại',
                  onPressed: () {
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
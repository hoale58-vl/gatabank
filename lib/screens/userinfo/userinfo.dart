import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/models/user.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/utils.dart';
import 'package:gatabank/utils/numeric_text_formatter.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/input_widget.dart';
import 'package:gatabank/widgets/popup_widget.dart';
import 'package:gatabank/widgets/row_item.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../config.dart';
import 'userinfo_bloc.dart';
import 'userinfo_states.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfoScreen>  {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserInfoCubit _userInfoCubit;

  TextEditingController incomeController = TextEditingController();
  TextEditingController loanExpectedController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _userInfoCubit = BlocProvider.of<UserInfoCubit>(context);
    _userInfoCubit.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        if (state is ShowError){
          Utils.errorToast(state.errorMsg);
        } else if (state is UpdateUserSuccess) {
          Navigator.pushNamed(context, ScreenRouter.ROOT);
        }
      },
      child: Scaffold(
        appBar: null,
        body: Container(
          color: App.theme.colors.background,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                  key: _formKey,
                  child: BlocBuilder<UserInfoCubit, UserInfoState>(
                    builder: (context, state) {
                      if (state is UserInfoLoaded){
                        return _buildUserInfoScreen(state);
                      }
                      return Container(
                        color: App.theme.colors.background,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  App.theme.colors.primary
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _buildUserInfoScreen(UserInfoLoaded state) {
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
                text: "So s??nh, ch???n l???a\nC??ch so s??nh c??ng b???ng nh???t",
                style: App.theme.styles.body6.copyWith(color: App.theme.colors.text1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Thu th???p h???ng\n th??ng c???a t??i l??", value: state.user.income != null ? Utils.localeCurrency(state.user.income.toDouble()) : '').getWidget(
          onTap: () => {
            _handleInputUserInfo(
              child: InputWidget(
                  controller: incomeController,
                  title: 'Thu nh???p h???ng th??ng',
                  onSaved: (value) => state.user.income = value,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  NumericTextFormatter()
                ],
              ),
              onSubmit: () => _userInfoCubit.updateIncome(incomeController.text.replaceAll(",", ""))
            )
          }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "T??i mu???n vay", value: state.user.loanExpected != null ? Utils.localeCurrency(state.user.loanExpected.toDouble()) : '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: InputWidget(
                    controller: loanExpectedController,
                    title: 'S??? ti???n mu???n vay',
                    onSaved: (value) => state.user.loanExpected = value,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      NumericTextFormatter()
                    ],
                  ),
                  onSubmit: () => _userInfoCubit.updateLoanExpected(loanExpectedController.text.replaceAll(",", ""))
              )
            }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "K?? h???n vay", value: state.user.loanTerm != null ? "${state.user.loanTerm.toString()} th??ng" : '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: Column(
                    children: [
                      Text(
                        "K??? h???n vay (th??ng)",
                        style: App.theme.styles.subTitle1.copyWith(color: App.theme.colors.text1),
                      ),
                      SizedBox(height: 10),
                      NumberPicker.integer(
                          initialValue: 3,
                          minValue: 1,
                          maxValue: 100,
                          onChanged: (value) {
                            state.user.loanTerm = value;
                          }
                      )
                    ],
                  ),
                  onSubmit: () => _userInfoCubit.updateLoanTerm(state.user.loanTerm)
              )
            }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "T??i s???ng ???", value: state.user.address ?? '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: InputWidget(
                    controller: addressController,
                    title: '?????a ch???',
                    onSaved: (value) => state.user.address = value,
                  ),
                  onSubmit: () => _userInfoCubit.updateAddress(addressController.text)
              )
            }
        ),
        SizedBox(
          height: 15,
        ),
        RowItem('', "T??i nh???n l????ng b???ng", value: state.user.salaryReceiveMethod ?? '').getWidget(
            onTap: () => {
              _handleInputUserInfo(
                  child: Column(
                    children: [
                      Text(
                        "Ph????ng th???c nh???n l????ng",
                        style: App.theme.styles.subTitle1.copyWith(color: App.theme.colors.text1),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: state.user.salaryReceiveMethod,
                        iconSize: 24,
                        elevation: 16,
                        style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
                        underline: Container(
                          height: 2,
                          color: App.theme.colors.text1,
                        ),
                        onChanged: (String newValue) {
                          _userInfoCubit.updateSalaryReceiveMethod(newValue);
                          Navigator.pop(context);
                        },
                        items: <String>['Ti???n m???t', 'Th??? t??n d???ng', 'Chuy???n kho???n', 'Kh??ng c??', 'Kh??c']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ),
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
                  title: "Xem k???t qu???",
                  enabled: state.submitBtnEnabled,
                ),
                SizedBox(
                  height: 20,
                ),
                ButtonWidget(
                  key: Key('BtnReset'),
                  onPressed: _handleResetForm,
                  title: "B???t ?????u l???i",
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
                        text: "B???ng c??ch b???m v??o n??t ",
                        style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                        children: <TextSpan>[
                          TextSpan(
                            text: "\"Xem k???t qu???\", ",
                            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
                            children: <TextSpan>[
                              TextSpan(
                                text: "t??i ?????ng ?? v???i ",
                                style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "c??c ??i???u kho???n v?? ch??nh s??ch b???o m???t ",
                                    style: App.theme.styles.button2.copyWith(color: App.theme.colors.primary),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "c???a ",
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
    Utils.showCustomDialog(context,
        title: "X??a d??? li???u hi???n t???i",
        content: "B???n c?? mu???n nh???p l???i th??ng tin t??i kho???n",
        onSubmit: () {
          _userInfoCubit.resetForm();
        }
    );
  }

  _handleConfirm() {
    if (_validateAndSave()) {
      _userInfoCubit.submitData();
    }
  }

  _handleInputUserInfo({VoidCallback onSubmit, @required Widget child}) async {
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
              actions: onSubmit != null ? <Widget>[
                ButtonWidget(
                  title: 'Quay l???i',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  buttonType: ButtonType.blue_border,
                ),
                SizedBox(
                  width: 25,
                ),
                ButtonWidget(
                  title: 'X??c nh???n',
                  onPressed: () {
                    onSubmit();
                    Navigator.pop(context);
                  },
                  buttonType: ButtonType.red_filled,
                )
              ] : [],
            ),
          );
        });
      }
}
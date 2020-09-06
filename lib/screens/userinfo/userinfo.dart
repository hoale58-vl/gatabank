import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/input_widget.dart';
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
  UserInfoBloc _userInfoBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _userInfoBloc = BlocProvider.of<UserInfoBloc>(context);
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
      },
      child: BlocBuilder<UserInfoBloc, UserInfoState>(
        bloc: _userInfoBloc,
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
        RowItem('', "Thu thập hằng\n tháng của tôi là", value: "200.000d" ?? '').getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi muốn vay", value: "50.000.000d" ?? '').getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Kì hạn vay", value: "12 tháng").getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi sống ở", value: "Sài gòn").getWidget(),
        SizedBox(
          height: 15,
        ),
        RowItem('', "Tôi nhận lương bằng", value: "Tiền mặt").getWidget(),
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

  _handleResetForm() {

  }

  _handleConfirm() {

  }
}
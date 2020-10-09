import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';

import '../../config.dart';
import '../../screen_router.dart';
import '../../utils.dart';

class CreditCardScreen extends StatefulWidget {
  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.theme.colors.background1,
        title: Text("Thẻ tín dụng"),
        actions: <Widget>[
          InkWell(
            onTap: () => Utils.showCustomDialog(context,
                title: "Nhập lại thông tin",
                content: "Bạn có muốn nhập lại thông tin tài khoản",
                onSubmit: () {
                  Navigator.pushNamed(context, ScreenRouter.USER_INFO);
                }
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                  Icons.update
              ),
            ),
          ),
          InkWell(
            onTap: () => Utils.showCustomDialog(context,
                title: "Đăng xuất",
                content: "Bạn có muốn đăng xuất tài khoản",
                onSubmit: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                }
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                  Icons.exit_to_app
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Image(image: AssetImage('assets/credit_card.png')),
        ],
      ),
    );
  }

}
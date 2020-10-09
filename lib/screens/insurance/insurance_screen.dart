import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';

import '../../config.dart';
import '../../screen_router.dart';
import '../../utils.dart';

class InsuranceScreen extends StatefulWidget {
  @override
  _InsuranceState createState() => _InsuranceState();
}

class _InsuranceState extends State<InsuranceScreen> {

  _buildGridItem(String icon, String label) => Container(
    padding: EdgeInsets.all(10),
    child: Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          App.theme.getSvgPicture(icon),
          SizedBox(height: 10,),
          Text(
            label,
            textAlign: TextAlign.center,
            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.theme.colors.background1,
        title: Text("Bảo Hiểm"),
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
          Image(image: AssetImage('assets/insurance.png')),
          SizedBox(height: 10),
          Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 7/4,
                children: [
                  _buildGridItem("human_insurance", "Bảo hiểm nhân thọ"),
                  _buildGridItem("health_insurance", "Bảo hiểm sức khỏe"),
                  _buildGridItem("sick_insurance", "Bảo hiểm \nbệnh hiểm nghèo"),
                  _buildGridItem("travel_insurance", "Bảo hiểm du lịch"),
                  _buildGridItem("home_insurance", "Bảo hiểm nhà"),
                  _buildGridItem("car_insurance", "Bảo hiểm ô tô")
                ]
            ),
          )
        ],
      ),
    );
  }

}
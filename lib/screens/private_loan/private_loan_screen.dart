import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/screens/private_loan/private_loan_cubit.dart';
import 'package:gatabank/screens/private_loan/private_loan_states.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/row_item.dart';


class PrivateLoanScreen extends StatefulWidget {
  PrivateLoanScreen();

  @override
  _PrivateLoanScreenState createState() => _PrivateLoanScreenState();
}

class _PrivateLoanScreenState extends State<PrivateLoanScreen>  {
  PrivateLoanCubit _privateLoanCubit;

  @override
  Widget build(BuildContext context) {
    _privateLoanCubit = BlocProvider.of<PrivateLoanCubit>(context);

    return BlocListener<PrivateLoanCubit, PrivateLoanState>(
      listener: (context, state) {},
      child: BlocBuilder<PrivateLoanCubit, PrivateLoanState>(
        cubit: _privateLoanCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: App.theme.colors.background1,
              title: Text("Vay Tín Dụng"),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.menu,
                        size: 26.0,
                      ),
                    )
                ),
              ],
            ),
            body: Container(
              color: App.theme.colors.background,
              child: _buildPrivateLoanScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBankName(bool active, String name, String trailing) => Card(
      elevation: 7,
      margin: EdgeInsets.all(10),
      color: active ? App.theme.colors.background1 : App.theme.colors.background,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: App.theme.getSvgPicture(
                active ? "stick_on": "stick_off",
                width: 30
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(name, style: App.theme.styles.subTitle1.copyWith(color: active ? App.theme.colors.background : App.theme.colors.text1),),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Image(image: AssetImage('assets/$trailing.png')),
          ),
        ],
      )
  );

  Widget _buildSelection(String name) => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
          child: Icon(
            Icons.keyboard_arrow_right,
            size: 25.0,
            color: App.theme.colors.button1,
          ),
        )
      ],
    )
  );

  Widget _buildFilter() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: App.theme.colors.background1,
    child: ExpansionTile(
      title: Text(
        "Lọc theo".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.background),
      ),
      children: [
        RowItem(
          "stick_off",
          "Trả mỗi tháng",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(),
        RowItem(
          "stick_off",
          "Tổng phải trả",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(),
        RowItem(
          "stick_off",
          "Khuyến mãi",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(),
        RowItem(
          "stick_off",
          "Lãi suất",
            disableTrailing: true,
            hasDivider: false,
            backGroundColor: App.theme.colors.background
        ).getWidget()
      ],
    ),
  );

  Widget _buildListResult(String logo) => Card(
    elevation: 7,
    margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Image(image: AssetImage('assets/$logo.png')),
        SizedBox(
          height: 10,
        ),
        Text("Vay tín chấp, thu nhập từ lương và\n tự doanh", style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1), textAlign: TextAlign.center,),
        SizedBox(
          height: 20,
        ),
        InkWell(
          child: RichText(
            text: TextSpan(
              text: "2.769.968đ /",
              style: App.theme.styles.subTitle1.copyWith(color: App.theme.colors.text1),
              children: [
                TextSpan(
                  text: "tháng",
                    style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1)
                )
              ]
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        App.theme.getSvgPicture(
          "ratio_bar",
        ),
        SizedBox(
          height: 10,
        ),
        RowItem(
          "loan_circle",
          "Gốc",
          value: "50.000.000 đ",
          hasDivider: false,
          disableTrailing: true,
            padding: EdgeInsets.only(top: 10, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "interest_circle",
            "Lãi suất",
            value: "16.479.237 đ",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Tổng phải trả",
            value: "66.479.237 đ",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Lãi suất tham khảo",
            value: "29%",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Thu nhập tối thiểu",
            value: "3.000.000 đ",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Kì hạn vay tối đa",
            value: "3 năm",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Thời gian duyệt vay",
            value: "2-3 ngày",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWidget(
              title: "So sánh".toUpperCase(),
              onPressed: () => {},
            ),
            ButtonWidget(
              title: "Tìm hiểu thêm".toUpperCase(),
              onPressed: () => {},
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: ButtonWidget(
            title: "Đăng ký ngay".toUpperCase(),
            onPressed: () => {},
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );

  Widget _buildPrivateLoanScreen() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        Text("Tên ngân hàng".toUpperCase(), style: App.theme.styles.title2.copyWith(color: App.theme.colors.text1), textAlign: TextAlign.center,),
        SizedBox(
          height: 40,
        ),
        _buildBankName(true, "Easy Credit", "easy_credit"),
        _buildBankName(false, "Lotte Finance", "lotte"),
        _buildBankName(false, "Prudential Finance", "prudential"),
        SizedBox(
          height: 35,
        ),
        _buildSelection("Cách tính lãi và trả nợ".toUpperCase()),
        _buildSelection("Loại lãi suất".toUpperCase()),
        _buildSelection("Chỉ hiện sản phẩm có\n khuyến mãi".toUpperCase()),
        SizedBox(
          height: 20,
        ),
        _buildFilter(),
        SizedBox(
          height: 40,
        ),
        Text("Tìm thấy 3 sản phẩm", textAlign: TextAlign.center),
        SizedBox(
          height: 30,
        ),
        _buildListResult("ocb")
      ],
    );
  }

}
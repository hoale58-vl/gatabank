import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/screens/loan_detail/loan_detail_cubit.dart';
import 'package:gatabank/screens/loan_detail/loan_detail_states.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/row_item.dart';


class LoanDetailScreen extends StatefulWidget {
  LoanDetailScreen();

  @override
  _LoanDetailScreenState createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen>  {
  LoanDetailCubit _loanDetailCubit;

  @override
  Widget build(BuildContext context) {
    _loanDetailCubit = BlocProvider.of<LoanDetailCubit>(context);

    return BlocListener<LoanDetailCubit, LoanDetailState>(
      listener: (context, state) {},
      child: BlocBuilder<LoanDetailCubit, LoanDetailState>(
        cubit: _loanDetailCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(200.0),
                child: AppBar(
                  backgroundColor: App.theme.colors.background1,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/prudential_header.png",
                          height: 80,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Vay tín chấp, thu nhập từ lương và tự doanh",
                          style: App.theme.styles.subTitle1.copyWith(color: App.theme.colors.background),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: RichText(
                            text: TextSpan(
                                text: "2.769.968đ /",
                                style: App.theme.styles.title2.copyWith(color: App.theme.colors.background),
                                children: [
                                  TextSpan(
                                      text: "tháng",
                                      style: App.theme.styles.title5.copyWith(color: App.theme.colors.background)
                                  )
                                ]
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
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
                )
            ),
            body: Container(
              color: App.theme.colors.background,
              child: _buildLoanDetailScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentDetail() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Chi tiết số tiền phải trả".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        Container(
          color: App.theme.colors.background,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 50,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Container(
                              height: 10,
                              width: double.infinity,
                              color: App.theme.colors.background1
                          ),
                        ),
                      )
                  ),
                  Expanded(
                    flex: 16,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Container(
                            height: 10,
                            width: double.infinity,
                            color: Color(0xFF113311)
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              RowItem(
                  "loan_circle",
                  "Gốc",
                  value: "50.000.000 đ",
                  hasDivider: false,
                  disableTrailing: true,
                  padding: EdgeInsets.only(left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "interest_circle",
                  "Lãi suất",
                  value: "16.479.237 đ",
                  hasDivider: false,
                  disableTrailing: true,
                  padding: EdgeInsets.only(left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Tổng phải trả",
                  value: "66.479.237 đ",
                  hasDivider: false,
                  disableTrailing: true,
                  padding: EdgeInsets.only(left: 20, right: 10)
              ).getWidget(),
            ],
          ),
        )
      ],
    ),
  );

  Widget _buildMainDetail() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Thông tin chính".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        Container(
          color: App.theme.colors.background,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              RowItem(
                  "",
                  "Lãi suất tham khảo",
                  value: "18 %",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Loại Lãi suất",
                  value: "Cố định",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Cách tính lãi và trả nợ",
                  value: "Lãi suất cố định -\n Số tiền phải trả\ncố định",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),

              RowItem(
                  "",
                  "Thu nhập tối thiểu",
                  value: "3.500.000 đ",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Số tiền vay tối thiểu",
                  value: "10.000.000 đ",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Số tiền vay tối đa",
                  value: "100.000.000 đ",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Kì hạn vay tối thiểu",
                  value: "1 năm",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Kì hạn vay tối đa",
                  value: "4 năm",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Thời gian duyệt vay",
                  value: "Trong ngày",
                  disableTrailing: true,
                  hasDivider: false,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
            ],
          ),
        )
      ],
    ),
  );

  Widget _buildRequirement() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Yêu cầu nào để mở\nhồ sơ vay?".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        Container(
          color: App.theme.colors.background,
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              RowItem(
                  "",
                  "Tuổi",
                  value: "Từ 21",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Chứng minh nhân thân",
                  value: "CMND",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Chứng minh thu nhập",
                  value: "Một trong các giấy tờ sau:\n Hợp Đồng Lao Động\n Hợp đồng bảo hiểm nhân thọ\n Bảng lương\n Giấy xác nhận lương\n Hợp đồng bảo hiểm nhân thọ trên 1 năm\n Thẻ tín dụng",
                  disableTrailing: true,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
              RowItem(
                  "",
                  "Chứng minh nơi cư trú",
                  value: "Hộ khẩu/KT3",
                  disableTrailing: true,
                  hasDivider: false,
                  padding: EdgeInsets.only(top:10, left: 20, right: 10)
              ).getWidget(),
            ],
          ),
        )
      ],
    ),
  );

  Widget _buildLoanDetailScreen() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        _buildPaymentDetail(),
        SizedBox(
          height: 30,
        ),
        _buildMainDetail(),
        SizedBox(
          height: 30,
        ),
        _buildRequirement(),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: ButtonWidget(
                margin: EdgeInsets.symmetric(horizontal: 10),
                title: "So sánh".toUpperCase(),
                buttonType: ButtonType.gray_filled,
                onPressed: () => {},
              ),
            ),
            Expanded(
              flex: 1,
              child: ButtonWidget(
                margin: EdgeInsets.symmetric(horizontal: 10),
                title: "Đăng ký".toUpperCase(),
                buttonType: ButtonType.orange_filled,
                onPressed: () => {},
              ),
            )
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

}
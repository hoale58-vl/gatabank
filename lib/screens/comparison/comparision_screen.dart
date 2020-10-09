import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/models/bank.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/comparison/comparision_cubit.dart';
import 'package:gatabank/screens/comparison/comparision_state.dart';
import 'package:gatabank/utils.dart';
import 'package:gatabank/widgets/ratio_bar.dart';
import 'package:gatabank/widgets/row_item.dart';

import '../../screen_router.dart';

class ComparisionScreen extends StatefulWidget {
  final List<Bank> banksList;
  final Bank selectedBank;
  ComparisionScreen({@required this.banksList, @required this.selectedBank});

  @override
  _ComparisionScreenState createState() => _ComparisionScreenState();
}

class _ComparisionScreenState extends State<ComparisionScreen>  {

  ComparisionCubit comparisonCubit;

  @override
  void initState(){
    super.initState();
    comparisonCubit = BlocProvider.of<ComparisionCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: App.theme.colors.background1,
        title: Text("So sánh"),
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
      body: Container(
        color: App.theme.colors.background,
        child: BlocBuilder<ComparisionCubit, ComparisionState>(
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  _buildBankCard(Bank bank, {bool selected = true}) => Expanded(
    child: Stack(
        children:[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 7,
              child: bank != null ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Image(image: AssetImage(bank.image), height: 40,),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Vay tín chấp, thu nhập từ lương \nvà tự doanh",
                      style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
                      textAlign: TextAlign.center
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "${Utils.currencyFormat(2769968)} /",
                        style: App.theme.styles.subTitle1.copyWith(color: App.theme.colors.text1),
                        children: [
                          TextSpan(
                              text: "tháng",
                              style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1)
                          )
                        ]
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ) : Center(
                child: GestureDetector(
                  child: Icon(Icons.add_circle_outline, size: 80),
                  onTap: () async {
                    Bank comparedBank = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) => ListView.builder(
                        itemCount: widget.banksList.length,
                        itemBuilder: (context, index) => GestureDetector(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(widget.banksList[index].name),
                              )
                          ),
                          onTap: () => Navigator.pop(context, widget.banksList[index]),
                        ),
                      )
                    );
                    comparisonCubit.addComparedBank(comparedBank);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: (){
                selected ? Navigator.of(context).pop() : comparisonCubit.removeComparedBank();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          )
        ]
    ),
  );

  _buildDiscountCard(Bank bank) => Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: bank != null && bank.discounts.length > 0 ? Column(
        children:
          bank.discounts.map((bankDiscount) => Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                bankDiscount.label,
                textAlign: TextAlign.center,
                style: App.theme.styles.subTitle1.copyWith(color: App.theme.colors.text1),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                bankDiscount.description,
                textAlign: TextAlign.center,
                style: App.theme.styles.body2.copyWith(color: App.theme.colors.text1),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )
        ).toList(),
      ) : Text("-", textAlign: TextAlign.center,),
    ),
  );

  _buildPaymentCard(Bank bank) => Expanded(
    child: bank != null ? Column(
      children: [
        SizedBox(
          height: 10,
        ),
        RatioBar(50, 16),
        SizedBox(
          height: 10,
        ),
        RowItem(
            "loan_circle",
            "Gốc",
            hasDivider: false,
            disableTrailing: true,
            sizedBox: 0,
            padding: EdgeInsets.symmetric(horizontal: 10)
        ).getWidget(),
        Text(
            Utils.currencyFormat(50000000),
            textAlign: TextAlign.end,
            style: App.theme.styles.subTitle2
                .copyWith(color: App.theme.colors.primary)
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Divider(
            thickness: 0.5,
            height: 1,
            color: App.theme.colors.divider,
          ),
        ),
        RowItem(
            "interest_circle",
            "Lãi suất",
            hasDivider: false,
            disableTrailing: true,
            sizedBox: 0,
            padding: EdgeInsets.symmetric(horizontal: 10)
        ).getWidget(),
        Text(
            Utils.currencyFormat(50000000 * bank.interestPercentage),
            textAlign: TextAlign.end,
            style: App.theme.styles.subTitle2
                .copyWith(color: App.theme.colors.primary)
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Divider(
            thickness: 0.5,
            height: 1,
            color: App.theme.colors.divider,
          ),
        ),
        RowItem(
            "",
            "Tổng phải trả",
            hasDivider: false,
            disableTrailing: true,
            sizedBox: 0,
            padding: EdgeInsets.symmetric(horizontal: 10)
        ).getWidget(),
        Text(
            Utils.currencyFormat(50000000 * (1 + bank.interestPercentage)),
            textAlign: TextAlign.end,
            style: App.theme.styles.subTitle2
                .copyWith(color: App.theme.colors.primary)
        ),
        SizedBox(
          height: 10,
        ),
      ],
    ) : Center(child: Text("-")),
  );

  _buildMainInfoCard(Bank bank) {
    var textStyle = App.theme.styles.body1.copyWith(color: App.theme.colors.text1);
    return Expanded(
      child: bank != null ? Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${bank.interestPercentage}%",
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              "-",
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.interestType,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.interestCalMethod,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              Utils.localeCurrency(bank.minIncome.toDouble()),
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              Utils.localeCurrency(bank.minLoanAmount.toDouble()),
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              Utils.localeCurrency(bank.maxLoanAmount.toDouble()),
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.minLoanTerm,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.maxLoanTerm,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.verifiedIn,
              textAlign: TextAlign.center,
              style: textStyle,
            )
          ],
        ),
      ) : Center(child: Text("-")),
    );
  }

  _buildFeeCard(Bank bank) => Expanded(
    child: bank != null ? Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            bank.bankFee.penaltyInterest,
            textAlign: TextAlign.center,
            style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: App.theme.colors.divider,
          ),
          Text(
            bank.bankFee.penaltyFee,
            textAlign: TextAlign.center,
            style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: App.theme.colors.divider,
          ),
          Text(
            bank.bankFee.earlierPaymentFee,
            textAlign: TextAlign.center,
            style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
          )
        ],
      ),
    ) : Center(child: Text("-"))
  );

  _buildRequirementCard(Bank bank) {
    var textStyle = App.theme.styles.body1.copyWith(color: App.theme.colors.text1);
    return Expanded(
      child: bank != null && bank.requirement != null ? Container(
        height: 300,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              bank.requirement.age,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.requirement.personalIdentifier,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.requirement.incomeIdentifier,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.requirement.homeIdentifier,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: App.theme.colors.divider,
            ),
            Text(
              bank.requirement.other ?? "-",
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ],
        ),
      ) : Center(child: Text("-")),
    );
  }

  _buildContent(BuildContext context, ComparisionState state) => ListView (
    children: [
      SizedBox(height: 20),
      IntrinsicHeight(
        child: Row(
          children: [
            _buildBankCard(widget.selectedBank),
            VerticalDivider(
              color: App.theme.colors.divider,
              thickness: 0.5,
              width: 1,
            ),
            _buildBankCard(state is ComparedBankPicked ? state.comparedBank : null, selected: false),
          ],
        ),
      ),
      SizedBox(height: 10),
      Card(
        elevation: 7,
        margin: EdgeInsets.all(10),
        color: Color(0xFFF6F3F3),
        child: ExpansionTile(
          title: Text(
            "Khuyến mãi".toUpperCase(),
            textAlign: TextAlign.right,
            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
          ),
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  _buildDiscountCard(widget.selectedBank),
                  VerticalDivider(
                    width: 1,
                    thickness: 0.5,
                    color: App.theme.colors.divider,
                  ),
                  _buildDiscountCard(state is ComparedBankPicked ? state.comparedBank : null),
                ],
              ),
            )
          ],
        ),
      ),
      SizedBox(height: 10),
      Card(
        elevation: 7,
        margin: EdgeInsets.all(10),
        color: Color(0xFFF6F3F3),
        child: ExpansionTile(
          title: Text(
            "Chi tiết số tiền phải trả".toUpperCase(),
            textAlign: TextAlign.right,
            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
          ),
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  _buildPaymentCard(widget.selectedBank),
                  VerticalDivider(
                    width: 1,
                    thickness: 0.5,
                    color: App.theme.colors.divider,
                  ),
                  _buildPaymentCard(state is ComparedBankPicked ? state.comparedBank : null),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Card(
        elevation: 7,
        margin: EdgeInsets.all(10),
        color: Color(0xFFF6F3F3),
        child: ExpansionTile(
          title: Text(
            "Thông tin chính".toUpperCase(),
            textAlign: TextAlign.right,
            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
          ),
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMainInfoCard(widget.selectedBank),
                  VerticalDivider(
                    width: 1,
                    thickness: 0.5,
                    color: App.theme.colors.divider,
                  ),
                  _buildMainInfoCard(state is ComparedBankPicked ? state.comparedBank : null),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Card(
        elevation: 7,
        margin: EdgeInsets.all(10),
        color: Color(0xFFF6F3F3),
        child: ExpansionTile(
          title: Text(
            "Phí".toUpperCase(),
            textAlign: TextAlign.right,
            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
          ),
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  _buildFeeCard(widget.selectedBank),
                  VerticalDivider(
                    width: 1,
                    thickness: 0.5,
                    color: App.theme.colors.divider,
                  ),
                  _buildFeeCard(state is ComparedBankPicked ? state.comparedBank : null),
                ],
              )
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Card(
        elevation: 7,
        margin: EdgeInsets.all(10),
        color: Color(0xFFF6F3F3),
        child: ExpansionTile(
          title: Text(
            "Yêu cầu nào để mở hồ sơ vay?".toUpperCase(),
            textAlign: TextAlign.right,
            style: App.theme.styles.subTitle2.copyWith(color: App.theme.colors.text1),
          ),
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  _buildRequirementCard(widget.selectedBank),
                  VerticalDivider(
                    color: App.theme.colors.divider,
                    thickness: 0.5,
                    width: 1,
                  ),
                  _buildRequirementCard(state is ComparedBankPicked ? state.comparedBank : null),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.all(40),
        child: Card(
          elevation: 6,
          child: Container(
            padding: EdgeInsets.all(20),
            color: Color(0xFFF8F8F8),
            child: Column(
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: 75,
                  height: 75,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                    "Thông tin được cung cấp bởi ngân hàng hoặc do GataBank liên hệ trực tiếp ngân hàng và chỉ mang tính tham khảo."
                        "Ngân hàng sẽ xác nhận lãi suất chính xác khi duyệt khoản vay. Lãi suất được cập nhật tháng 02/2019",
                  textAlign: TextAlign.center,
                  style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
                )
              ],
            ),
          )
        ),
      )
    ],
  );
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/models/bank.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/private_loan/private_loan_cubit.dart';
import 'package:gatabank/screens/private_loan/private_loan_states.dart';
import 'package:gatabank/utils.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/ratio_bar.dart';
import 'package:gatabank/widgets/row_item.dart';


class PrivateLoanScreen extends StatefulWidget {
  PrivateLoanScreen();

  @override
  _PrivateLoanScreenState createState() => _PrivateLoanScreenState();
}

class _PrivateLoanScreenState extends State<PrivateLoanScreen>  {
  PrivateLoanCubit _privateLoanCubit;
  String _filterType = FilterType.PAYMENT_EACH_MONTH;

  @override
  void initState(){
    super.initState();
    _privateLoanCubit = BlocProvider.of<PrivateLoanCubit>(context);
    _privateLoanCubit.getListBanks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrivateLoanCubit, PrivateLoanState>(
      listener: (context, state) {
        if (state is UpdateFilterType){
          setState(() {
            _filterType = state.filterType;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: App.theme.colors.background1,
          title: Text("Vay Tín Dụng"),
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
          child: _buildPrivateLoanScreen(),
        ),
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
                active ? "stick_on_2": "stick_off",
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
            _filterType == FilterType.PAYMENT_EACH_MONTH ? "stick_on" : "stick_off",
          "Trả mỗi tháng: thấp đến cao",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () => _privateLoanCubit.setFilter(FilterType.PAYMENT_EACH_MONTH),
        ),
        RowItem(
            _filterType == FilterType.TOTAL_PAYMENT ? "stick_on" : "stick_off",
          "Tổng phải trả: thấp đến cao",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () => _privateLoanCubit.setFilter(FilterType.TOTAL_PAYMENT),
        ),
        RowItem(
            _filterType == FilterType.DISCOUNT ? "stick_on" : "stick_off",
          "Khuyến mãi",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () => _privateLoanCubit.setFilter(FilterType.DISCOUNT),
        ),
        RowItem(
            _filterType == FilterType.INTEREST ? "stick_on" : "stick_off",
          "Lãi suất: thấp đến cao",
            disableTrailing: true,
            hasDivider: false,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () => _privateLoanCubit.setFilter(FilterType.INTEREST),
        )
      ],
    ),
  );

  Widget _buildResultCard(BankListSuccess state, Bank bank) => Card(
    elevation: 7,
    margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Image(image: AssetImage(bank.image), height: 70,),
        SizedBox(
          height: 10,
        ),
        Text("Vay tín chấp, thu nhập từ lương và\n tự doanh",
          style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
          textAlign: TextAlign.center
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          child: RichText(
            text: TextSpan(
              text: "${Utils.currencyFormat(2769968)} /",
              style: App.theme.styles.title2.copyWith(color: App.theme.colors.text1),
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
        RatioBar(50, 16),
        SizedBox(
          height: 10,
        ),
        RowItem(
          "loan_circle",
          "Gốc",
          value: Utils.currencyFormat(50000000),
          hasDivider: false,
          disableTrailing: true,
            padding: EdgeInsets.only(top: 10, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "interest_circle",
            "Lãi suất",
            value: Utils.currencyFormat(50000000 * bank.interestPercentage),
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Tổng phải trả",
            value: Utils.currencyFormat(50000000 * (1 + bank.interestPercentage)),
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Lãi suất tham khảo",
            value: "${bank.interestPercentage}%",
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Thu nhập tối thiểu",
            value: Utils.currencyFormat(bank.minIncome),
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Kì hạn vay tối đa",
            value: bank.maxLoanTerm,
            hasDivider: false,
            disableTrailing: true,
            padding: EdgeInsets.only(top: 5, left: 20, right: 10)
        ).getWidget(),
        RowItem(
            "",
            "Thời gian duyệt vay",
            value: bank.verifiedIn,
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
            Expanded(
              flex: 1,
              child: ButtonWidget(
                margin: EdgeInsets.symmetric(horizontal: 10),
                title: "So sánh".toUpperCase(),
                buttonType: ButtonType.gray_filled,
                onPressed: () => {
                  Navigator.pushNamed(context, ScreenRouter.COMPARISION, arguments: {
                    "banksList" : state.listBanks,
                    "bank": bank
                  })
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ButtonWidget(
                margin: EdgeInsets.symmetric(horizontal: 10),
                title: "Tìm hiểu".toUpperCase(),
                buttonType: ButtonType.white_filled,
                onPressed: () => Navigator.pushNamed(context, ScreenRouter.LOAN_DETAIL, arguments: bank),
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: ButtonWidget(
            margin: EdgeInsets.symmetric(horizontal: 10),
            title: "Đăng ký ngay".toUpperCase(),
            onPressed: () => {},
            buttonType: ButtonType.orange_filled,
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
          height: 20,
        ),
        BlocBuilder<PrivateLoanCubit, PrivateLoanState>(
          builder:(context, state) => state is BankListSuccess ? Column(
            children: [
              Text("Tìm thấy ${state.listBanks.length} dữ liệu", textAlign: TextAlign.center),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 720,
                child: Swiper(
                  outer: false,
                  itemBuilder: (BuildContext context, int index){
                    return _buildResultCard(state, state.listBanks[index]);
                  },
                  itemCount: state.listBanks.length,
                  pagination: SwiperPagination(),
                  control: SwiperControl(),
                ),
              )
            ],
          ): Text("Không tìm thấy dữ liệu khớp với bộ lọc", textAlign: TextAlign.center)
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
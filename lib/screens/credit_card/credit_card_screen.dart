import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/credit_card/credit_card_states.dart';
import 'package:gatabank/widgets/button_widget.dart';
import 'package:gatabank/widgets/row_item.dart';

import '../../config.dart';
import '../../screen_router.dart';
import '../../utils.dart';
import 'credit_card_cubit.dart';
import '../../models/card.dart' as CreditCard;

class CreditCardScreen extends StatefulWidget {
  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCardScreen> {
  CreditCardCubit _creditCardCubit;
  String _filterCardType = FilterCardType.VISA;
  String _filterDiscount = FilterDiscount.PRICE_REDUCE;
  String _filterOrder = FilterOrderBy.DISCOUNT;
  String _filterCalTool = FilterCalTool.REFUND;
  double yearlyFeeFilter = 500000;

  @override
  void initState(){
    super.initState();
    _creditCardCubit = BlocProvider.of<CreditCardCubit>(context);
    getCardList();
  }

  void getCardList(){
    _creditCardCubit.getListCards(
      cardType: _filterCardType,
      discount: _filterDiscount,
      order: _filterOrder,
      calTool: _filterCalTool
    );
  }

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
      body: ListView(
        children: [
          Image(image: AssetImage('assets/credit_card.png')),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Text(
                    "Phí thường niên".toUpperCase(),
                    style: App.theme.styles.title4.copyWith(color: App.theme.colors.text1)
                ),
                Slider(
                    value: yearlyFeeFilter,
                    min: 500000.0,
                    max: 1900000.0,
                    divisions: 1000,
                    activeColor: App.theme.colors.background1,
                    inactiveColor: Color(0xFFF6F3F3),
                    label: 'Phí thường niên: ${Utils.localeCurrency(yearlyFeeFilter)}',
                    onChanged: (double newValue) {
                      setState(() {
                        yearlyFeeFilter = newValue;
                      });
                    },
                    semanticFormatterCallback: (double newValue) {
                      return Utils.localeCurrency(newValue);
                    }
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      Utils.localeCurrency(500000.0),
                      textAlign: TextAlign.start,
                      style: App.theme.styles.body1,
                    ),
                    Expanded(
                      child: Text(
                        Utils.localeCurrency(1900000.0),
                        textAlign: TextAlign.end,
                        style: App.theme.styles.body1,
                      )
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                _buildFilterCardType(),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                _buildFilterDiscount(),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                _buildFilterOrderBy(),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                _buildFilterCalTool(),
                SizedBox(
                  height: 15,
                ),
                BlocBuilder<CreditCardCubit, CreditCardState>(
                    builder:(context, state) => state is CardListSuccess ? Column(
                      children: [
                        Text("Tìm thấy ${state.listCards.length} dữ liệu", textAlign: TextAlign.center),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 720,
                          child: Swiper(
                            outer: false,
                            itemBuilder: (BuildContext context, int index){
                              return _buildResultCard(state, state.listCards[index]);
                            },
                            itemCount: state.listCards.length,
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
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterCardType() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Loại thẻ".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        RowItem(
            _filterCardType == FilterCardType.VISA ? "stick_on" : "stick_off",
            "VISA",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCardType = FilterCardType.VISA;
            getCardList();
          },
        ),
        RowItem(
            _filterCardType == FilterCardType.AMEX ? "stick_on" : "stick_off",
            "AMEX",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCardType = FilterCardType.AMEX;
            getCardList();
          },
        ),
        RowItem(
            _filterCardType == FilterCardType.MasterCard ? "stick_on" : "stick_off",
            "MasterCard",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCardType = FilterCardType.MasterCard;
            getCardList();
          },
        ),
        RowItem(
            _filterCardType == FilterCardType.UnionPay ? "stick_on" : "stick_off",
            "UnionPay",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCardType = FilterCardType.UnionPay;
            getCardList();
          },
        ),
        RowItem(
            _filterCardType == FilterCardType.JCB ? "stick_on" : "stick_off",
            "JCB",
            disableTrailing: true,
            hasDivider: false,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCardType = FilterCardType.JCB;
            getCardList();
          },
        )
      ],
    ),
  );

  Widget _buildFilterDiscount() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Khuyến mãi".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        RowItem(
            _filterDiscount == FilterDiscount.PRICE_REDUCE ? "stick_on" : "stick_off",
            "Giảm giá",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterDiscount = FilterDiscount.PRICE_REDUCE;
            getCardList();
          },
        ),
        RowItem(
            _filterDiscount == FilterDiscount.REFUND_AND_GIFT ? "stick_on" : "stick_off",
            "Hoàn tiền & quà tặng",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterDiscount = FilterDiscount.REFUND_AND_GIFT;
            getCardList();
          },
        ),
        RowItem(
            _filterDiscount == FilterDiscount.YEARLY_FEE_FREE_AND_GIRFT ? "stick_on" : "stick_off",
            "Miễn phí thường niên & quà tặng",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterDiscount = FilterDiscount.YEARLY_FEE_FREE_AND_GIRFT;
            getCardList();
          },
        ),
        RowItem(
            _filterDiscount == FilterDiscount.HIGH_QUALITY_GIFT ? "stick_on" : "stick_off",
            "Quà tặng cao cấp",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterDiscount = FilterDiscount.HIGH_QUALITY_GIFT;
            getCardList();
          },
        ),
        RowItem(
            _filterDiscount == FilterDiscount.ZERO_INSTALLMENT ? "stick_on" : "stick_off",
            "Trả góp lãi suất 0%",
            disableTrailing: true,
            hasDivider: false,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterDiscount = FilterDiscount.ZERO_INSTALLMENT;
            getCardList();
          },
        )
      ],
    ),
  );

  Widget _buildFilterOrderBy() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Sắp xếp theo".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        RowItem(
            _filterOrder == FilterOrderBy.DISCOUNT ? "stick_on" : "stick_off",
            "Khuyến mãi mở thẻ",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterOrder = FilterOrderBy.DISCOUNT;
            getCardList();
          },
        ),
        RowItem(
            _filterOrder == FilterOrderBy.RATING ? "stick_on" : "stick_off",
            "Đánh giá chung",
            disableTrailing: true,
            hasDivider: false,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterOrder = FilterOrderBy.RATING;
            getCardList();
          },
        ),
      ],
    ),
  );

  Widget _buildFilterCalTool() => Card(
    elevation: 7,
    margin: EdgeInsets.all(10),
    color: Color(0xFFF6F3F3),
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        "Công cụ tính toán".toUpperCase(),
        textAlign: TextAlign.center,
        style: App.theme.styles.title5.copyWith(color: App.theme.colors.text1),
      ),
      children: [
        RowItem(
            _filterCalTool == FilterCalTool.REFUND ? "stick_on" : "stick_off",
            "Hoàn tiền",
            disableTrailing: true,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCalTool = FilterCalTool.REFUND;
            getCardList();
          },
        ),
        RowItem(
            _filterCalTool == FilterCalTool.DISTANCE ? "stick_on" : "stick_off",
            "Khoảng cách",
            disableTrailing: true,
            hasDivider: false,
            backGroundColor: App.theme.colors.background
        ).getWidget(
          onTap: () {
            _filterCalTool = FilterCalTool.DISTANCE;
            getCardList();
          },
        ),
      ],
    ),
  );

  Widget _buildResultCard(CardListSuccess state, CreditCard.Card card) => Card(
    elevation: 7,
    margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text("${card.name} - By ${card.sponsor}",
            style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
            textAlign: TextAlign.center
        ),
        card.subtitle != null ? Text("${card.subtitle}",
            style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
            textAlign: TextAlign.center
        ) : Container(),
        Text("(Đánh giá chung ${card.rating}/5)",
            style: App.theme.styles.body1.copyWith(color: App.theme.colors.text1),
            textAlign: TextAlign.center
        ),
        SizedBox(
          height: 10,
        ),
        Image(image: AssetImage(card.image), height: 70,),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Row(
            children: [
              App.theme.getSvgPicture("discount_mail"),
              Column(
                children: [
                  Text("Khuyến mãi".toUpperCase()),
                  Text("Giảm giá 15% trên tổng hóa đơn TIPSY ART"),
                ],
              )
            ]
          )
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Yêu cầu thu nhập"),
            Text(Utils.localeCurrency(card.cardRequirement.incomeRequirement.toDouble())),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Divider(thickness: 0.5,height: 1, color: App.theme.colors.divider),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text("Phí thường niên"),
            Text(Utils.localeCurrency(card.cardBasic.yearlyFee.toDouble())),
          ],
        ),
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
                    "cardsList" : state.listCards,
                    "card": card
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
                onPressed: () => Navigator.pushNamed(context, ScreenRouter.CREDIT_CARD_DETAIL, arguments: card),
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
}
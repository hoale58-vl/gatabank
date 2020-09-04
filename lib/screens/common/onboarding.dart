import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/widgets/common/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  SwiperController _swipeController;
  int _currentPage = 0;
  List<Image> _images;
  List titles, descriptions;

  @override
  void initState() {
    _swipeController = SwiperController();
    _initialList();
    _images = List<Image>.generate(titles.length,
            (i) => Image(image: AssetImage('assets/onboarding_${i + 1}${App.theme.suffix}.png')));
    super.initState();
  }

  _initialList() {
    titles = [
      LocaleKeys.onboarding_hello_welcome_to_toko_w.tr(),
      LocaleKeys.onboarding_all_assets_in_one_place.tr(),
      LocaleKeys.onboarding_private_and_secure.tr(),
      LocaleKeys.onboarding_experience_blockchain_technology.tr()
    ];

    descriptions = [
      LocaleKeys.onboarding_experience_a_trading_platform_powered_by_tokoin.tr(),
      LocaleKeys.onboarding_store_and_manage_your_assets.tr(),
      LocaleKeys.onboarding_trade_your_assets_anonymously.tr(),
      LocaleKeys.onboarding_earn_trade_explore_utilize_tokoin.tr()
    ];
  }

  @override
  Widget build(BuildContext context) {
    int pageCount = titles.length;

    return Scaffold(
      backgroundColor: App.theme.colors.background,
      body: WillPopScope(
        onWillPop: () async => Future.value(false), // disable back button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItem(context, index);
                    },
                    itemCount: pageCount,
                    pagination: _indicator(),
                    controller: _swipeController,
                    loop: false,
                    onIndexChanged: (int index) => {
                      setState(() {
                        _currentPage = index;
                      })
                    })),
            SizedBox(height: 30),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    width: _isFinalPage() ? 200 : 150,
                    child: ButtonWidget(
                      key: Key('BtnNext'),
                      onPressed: _nextPage,
                      title: _isFinalPage()
                          ? LocaleKeys.onboarding_lets_start.tr()
                          : LocaleKeys.onboarding_next.tr(),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _nextPage() =>
      _isFinalPage() ? Navigator.of(context).pop() : _swipeController.next(animation: true);

  _isFinalPage() => _currentPage == titles.length - 1;

  _indicator() => SwiperPagination(
      margin: EdgeInsets.all(0),
      builder: new DotSwiperPaginationBuilder(
          color: App.theme.colors.dot,
          activeColor: App.theme.colors.primary,
          space: 3,
          size: 6,
          activeSize: 6));

  _buildItem(BuildContext context, int index) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        child: _images[index],
        width: 250,
        height: 250,
      ),
      Padding(
        padding: EdgeInsets.only(top: 40, bottom: 10),
        child: Text(titles[index],
            style: App.theme.styles.title4
                .copyWith(fontWeight: FontWeight.bold, color: App.theme.colors.primary),
            textAlign: TextAlign.center),
      ),
      Padding(child: Text(descriptions[index],
          style: App.theme.styles.body1.copyWith(color: App.theme.colors.text5),
          textAlign: TextAlign.center), padding: EdgeInsets.symmetric(horizontal: 30),),
    ],
  );
}

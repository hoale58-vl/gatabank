import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gatabank/widgets/button_widget.dart';

import '../../config.dart';

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
      "Chào mừng bạn đến GataBank",
    ];

    descriptions = [
      "Hoạch định những giải pháp tài chính mang đến sự bảo vệ toàn diện, sự đầu tư an toàn và phù hợp nhất cho bạn."
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
                      title: "Tiếp theo",
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
        child: Image.asset(
          "assets/logo.png",
          width: 185,
          height: 185,
        ),
        width: 250,
        height: 100,
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
      SizedBox(
        child: _images[index],
        width: 250,
        height: 250,
      ),
    ],
  );
}

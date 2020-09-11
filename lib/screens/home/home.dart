import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/home/home_cubit.dart';
import 'package:gatabank/screens/home/home_states.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  HomeCubit _homeCubit;
  SwiperController _swipeController;
  List<Image> _images;

  @override
  void initState() {
    _swipeController = SwiperController();
    _images = [Image(image: AssetImage('assets/home_slider_1.png'))];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is Navigate){
          switch(state.screen) {
            case ScreenRouter.PRIVATE_LOAN: {
              Navigator.pushNamed(context, ScreenRouter.PRIVATE_LOAN);
            }
            break;
            case ScreenRouter.CREDIT_CARD: {
              Navigator.pushNamed(context, ScreenRouter.CREDIT_CARD);
            }
            break;
            case ScreenRouter.INSURANCE: {
              Navigator.pushNamed(context, ScreenRouter.INSURANCE);
            }
            break;
          }
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        cubit: _homeCubit,
        builder: (context, state) {
          return Scaffold(
            body: Container(
              color: App.theme.colors.background,
              child: _buildHomeScreen(),
            ),
          );
        },
      ),
    );
  }

  _indicator() => SwiperPagination(
      margin: EdgeInsets.all(0),
      builder: new DotSwiperPaginationBuilder(
          color: App.theme.colors.dot,
          activeColor: App.theme.colors.primary,
          space: 3,
          size: 6,
          activeSize: 6));

  Widget _buildHomeScreen() {
    int pageCount = _images.length;

    return ListView(
      children: <Widget>[
        Container(
          height: 500,
          child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return FittedBox(child: _images[index], fit: BoxFit.fitWidth);
              },
              itemCount: pageCount,
              pagination: _indicator(),
              controller: _swipeController
            ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Image(image: AssetImage('assets/private_loan.png')),
          onTap: () => _homeCubit.navigate(ScreenRouter.PRIVATE_LOAN),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Image(image: AssetImage('assets/credit_card.png')),
          onTap: () => _homeCubit.navigate(ScreenRouter.CREDIT_CARD),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Image(image: AssetImage('assets/insurance.png')),
          onTap: () => _homeCubit.navigate(ScreenRouter.INSURANCE),
        ),
        SizedBox(
          height: 30,
        ),
        _buildFooter()
      ],
    );
  }


  Widget _buildFooter(){
    return Container(
        height: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/home_footer.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Image(image: AssetImage('assets/sample_avatar.png'), height: 80,),
            ),
            Padding(child: Text("Lê Việt Hòa",
                style: App.theme.styles.title4.copyWith(color: App.theme.colors.text6),
                textAlign: TextAlign.center), padding: EdgeInsets.symmetric(horizontal: 30),),
          ]
        )
    );
  }
}
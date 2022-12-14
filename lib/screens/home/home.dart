import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/auth/auth_states.dart';
import 'package:gatabank/screens/home/home_cubit.dart';
import 'package:gatabank/screens/home/home_states.dart';
import 'package:gatabank/widgets/app_bar_widget.dart';

import '../../utils.dart';


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
          return BlocListener<AuthCubit, AuthenticationState>(
            listener: (context, state){
              if (state is AuthenticationUnauthenticated){
                Navigator.pushNamedAndRemoveUntil(
                  context, ScreenRouter.ROOT, (route) => false);
              }
            },
            child: Scaffold(
              appBar: AppBarWidget(
                "Trang ch???",
                actions: [
                  InkWell(
                    onTap: () => Utils.showCustomDialog(context,
                        title: "Nh???p l???i th??ng tin",
                        content: "B???n c?? mu???n nh???p l???i th??ng tin t??i kho???n",
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
                        title: "????ng xu???t",
                        content: "B???n c?? mu???n ????ng xu???t t??i kho???n",
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
                child: _buildHomeScreen(),
              ),
            )
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
            Padding(child: Text("L?? Vi???t H??a",
                style: App.theme.styles.title4.copyWith(color: App.theme.colors.text6),
                textAlign: TextAlign.center), padding: EdgeInsets.symmetric(horizontal: 30),),
          ]
        )
    );
  }
}
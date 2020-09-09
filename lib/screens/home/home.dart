import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/screen_router.dart';

import 'home_bloc.dart';
import 'home_states.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  HomeCubit _homeCubit;

  @override
  Widget build(BuildContext context) {
    _homeCubit = BlocProvider.of<HomeCubit>(context);
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is Navigate){
          switch(state.screen) {
            case ScreenRouter.PRIVATE_LOAN: {
              // statements;
            }
            break;
            case ScreenRouter.CREDIT_CARD: {
              //statements;
            }
            break;
            case ScreenRouter.INSURANCE: {
              //statements;
            }
            break;
          }
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        cubit: _homeCubit,
        builder: (context, state) {
          return _buildHomeScreen();
        },
      ),
    );
  }

  Scaffold _buildHomeScreen() {
    return Scaffold();
  }
}
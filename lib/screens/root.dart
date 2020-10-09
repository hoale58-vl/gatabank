
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/home/home.dart';
import 'package:gatabank/screens/login/login.dart';
import 'package:gatabank/screens/userinfo/userinfo.dart';

import 'auth/auth_cubit.dart';
import 'auth/auth_states.dart';

class Root extends StatefulWidget {

  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    _setupFirstTimeLaunchApp();
    super.initState();
  }

  _setupFirstTimeLaunchApp() async {
    bool isFirstTimeLaunchApp = storage.isOnboardingEnabled();
    if (!isFirstTimeLaunchApp) return;
    _goToOnBoarding();
  }

  Future _goToOnBoarding() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, ScreenRouter.ONBOARDING);
    });
    storage.disableOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
            return state.user.updatedInfo() ? HomeScreen() : UserInfoScreen();
        }
        if (state is AuthenticationUnauthenticated) {
          return LoginScreen();
        }
        return Container(color: Colors.white);
      },
    );
  }
}

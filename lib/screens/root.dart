import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/auth/fcm_bloc.dart';
import 'package:gatabank/screens/home/home.dart';
import 'package:gatabank/screens/login/login.dart';
import 'package:gatabank/screens/login/login_bloc.dart';

import 'auth/auth_bloc.dart';
import 'auth/auth_states.dart';
import 'home/home_bloc.dart';

class Root extends StatefulWidget {
  final UserRepository userRepository;

  Root({Key key, this.userRepository}) : super(key: key);

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
    return BlocBuilder<AuthBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(
                create: (context) {
                  return HomeBloc(
                    userRepository: widget.userRepository,
                  );
                },
              ),
              BlocProvider<FcmBloc>(create: (context) {
                return FcmBloc(userRepository: widget.userRepository);
              }),
            ],
            child: HomeScreen(),
          );
        }

        if (state is AuthenticationUnauthenticated) {
          return BlocProvider<LoginBloc>(
            create: (context) {
              return LoginBloc(
                userRepository: widget.userRepository,
                authBloc: BlocProvider.of<AuthBloc>(context),
              );
            },
            child: LoginScreen(),
          );
        }

        return Container(color: Colors.white);
      },
    );
  }
}

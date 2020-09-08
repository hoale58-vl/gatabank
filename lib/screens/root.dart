import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/auth/fcm_cubit.dart';
import 'package:gatabank/screens/home/home.dart';
import 'package:gatabank/screens/login/login.dart';
import 'package:gatabank/screens/login/login_cubit.dart';
import 'package:gatabank/screens/userinfo/userinfo.dart';
import 'package:gatabank/screens/userinfo/userinfo_bloc.dart';

import 'auth/auth_cubit.dart';
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
    return BlocBuilder<AuthCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          if (state.user.updatedInfo()){
            return MultiBlocProvider(
              providers: [
                BlocProvider<HomeCubit>(
                  create: (context) {
                    return HomeCubit(
                      userRepository: widget.userRepository,
                    );
                  },
                ),
                BlocProvider<FcmCubit>(create: (context) {
                  return FcmCubit(userRepository: widget.userRepository);
                }),
              ],
              child: HomeScreen(),
            );
          } else {
            return MultiBlocProvider(
              providers: [
                BlocProvider<UserInfoCubit>(
                  create: (context) {
                    return UserInfoCubit(
                      userRepository: widget.userRepository,
                    );
                  },
                ),
                BlocProvider<FcmCubit>(create: (context) {
                  return FcmCubit(userRepository: widget.userRepository);
                }),
              ],
              child: UserInfoScreen(),
            );
          }
        }

        if (state is AuthenticationUnauthenticated) {
          return BlocProvider<LoginCubit>(
            create: (context) {
              return LoginCubit(
                userRepository: widget.userRepository,
                authCubit: BlocProvider.of<AuthCubit>(context),
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

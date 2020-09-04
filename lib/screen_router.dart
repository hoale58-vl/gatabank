import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/blocs/auth/auth_bloc.dart';
import 'package:gatabank/blocs/forgot_pwd/bloc.dart';
import 'package:gatabank/blocs/register/register_bloc.dart';
import 'package:gatabank/blocs/user/user_bloc.dart';
import 'package:gatabank/repositories/user_repos.dart';
import 'package:gatabank/root.dart';
import 'package:gatabank/screens/common/onboarding.dart';
import 'package:gatabank/screens/account/account.dart';
import 'package:gatabank/screens/account/submit_result.dart';
import 'package:gatabank/screens/account/input_phone.dart';
import 'package:gatabank/screens/auth/forgot_pwd.dart';
import 'package:gatabank/screens/account/verification_code.dart';
import 'package:gatabank/screens/auth/reset_pwd.dart';
import 'package:gatabank/screens/auth/register.dart';
import 'package:gatabank/widgets/common/button_widget.dart';

class ScreenRouter {
  static const ROOT = '/';
  static const ONBOARDING = 'onboarding';
  static const REGISTER = 'register';
  static const LOGIN = 'login';
  static const FORGOT_PWD = 'forgot_password';
  static const VERIFICATION_CODE = 'input_authentication_code';
  static const RESET_PWD = 'reset_pwd';
  static const PASSCODE = 'passcode';
  static const TICK_LIST_SCREEN = 'TICK_LIST_SCREEN';
  static const ACCOUNT_SCREEN = 'ACCOUNT_SCREEN';
  static const SUBMIT_RESULT_SCREEN = 'SUBMIT_RESULT_SCREEN';
  static const INPUT_PHONE = 'INPUT_PHONE';
  static const AGR_PHONE = 'AGR_PHONE';
  static const AGR_COUNTRY = 'AGR_COUNTRY';
  static const AGR_USER = 'AGR_USER';
  static const AGR_SCREEN_NAME = 'AGR_SCREEN_NAME';
  static const AGR_TITLE_LIST = 'AGR_TITLE_LIST';
  static const AGR_DESCRIPTION_LIST = 'AGR_DESCRIPTION_LIST';
  static const AGR_VERIFICATION_TYPE = 'AGR_VERIFICATION_TYPE';
  static const AGR_VERIFICATION_PHONE = 'AGR_VERIFICATION_PHONE';
  static const AGR_VERIFICATION_COUNTRY_CODE = 'AGR_VERIFICATION_COUNTRY_CODE';
  static const AGR_VERIFICATION_EMAIL = 'AGR_VERIFICATION_EMAIL';
  static const AGR_RECAPTCHA_TOKEN = "AGR_RECAPTCHA_TOKEN";
  static const AGR_IS_REGISTERING = 'AGR_IS_REGISTERING';
  static const AGR_EMAIL = 'AGR_EMAIL';

  UserRepository userRepos;
  AuthBloc authBloc;
  FirebaseAnalyticsObserver analyticsObserver;

  ScreenRouter(
      {this.userRepos,
        this.authBloc,
        this.analyticsObserver});

  Route<dynamic> generateRoute(RouteSettings settings) {
    Map arguments = settings.arguments;

    switch (settings.name) {
      case ROOT:
        return MaterialPageRoute(
          builder: (context) => Root(
            userRepository: userRepos,
            analyticsObserver: analyticsObserver,
          ),
          settings: settings,
        );

      case ONBOARDING:
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
          settings: settings,
        );
      case REGISTER:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider<RegisterBloc>(
              create: (context) {
                return RegisterBloc(
                  userRepository: userRepos,
                  authBloc: authBloc,
                );
              },
              child: RegisterScreen(authBloc),
            );
          },
          settings: settings,
        );

      case FORGOT_PWD:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider<ForgotPwdBloc>(
                create: (context) {
                  return ForgotPwdBloc(
                    userRepository: userRepos,
                  );
                },
                child: ForgotPwdScreen(),
              );
            },
            settings: settings);

      case INPUT_PHONE:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider<UserBloc>(
                create: (context) {
                  return UserBloc(
                    userRepository: userRepos,
                  );
                },
                child: InputPhoneScreen(
                  phone: arguments[AGR_PHONE],
                  countryCode: arguments[AGR_COUNTRY],
                ),
              );
            },
            settings: settings);

      case VERIFICATION_CODE:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider<UserBloc>(
                create: (context) {
                  return UserBloc(
                    userRepository: userRepos,
                  );
                },
                child: VerificationCodeScreen(
                  recaptchaToken: arguments[AGR_RECAPTCHA_TOKEN],
                  email: arguments[AGR_VERIFICATION_EMAIL],
                  phone: arguments[AGR_VERIFICATION_PHONE],
                  countryCode: arguments[AGR_VERIFICATION_COUNTRY_CODE],
                  verifiedType: arguments[AGR_VERIFICATION_TYPE],
                  isRegistering: arguments.containsKey(AGR_IS_REGISTERING)
                      ? arguments[AGR_IS_REGISTERING]
                      : false,
                ),
              );
            },
            settings: settings);

      case RESET_PWD:
        return MaterialPageRoute(
            builder: (context) {
              return BlocProvider<ForgotPwdBloc>(
                create: (context) {
                  return ForgotPwdBloc(
                    userRepository: userRepos,
                  );
                },
                child: ResetPwdScreen(
                  email: arguments['email'],
                  authenticationCode: arguments['authenticationCode'],
                ),
              );
            },
            settings: settings);
      case ACCOUNT_SCREEN:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider<UserBloc>(
                create: (context) {
                  return UserBloc(
                    userRepository: userRepos,
                  );
                },
                child: AccountScreen(
                  authBloc: authBloc,
                  isRegistering: arguments[AGR_IS_REGISTERING],
                ));
          },
          settings: settings,
        );

      case SUBMIT_RESULT_SCREEN:
        return MaterialPageRoute(
          builder: (context) => SubmitResultScreen(),
          settings: settings,
        );
      default:
        return unknownRoute(settings);
    }
  }

  Route<dynamic> unknownRoute(RouteSettings settings) {
    var unknownRouteText = "No such screen for ${settings.name}";

    return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(unknownRouteText),
          Padding(padding: const EdgeInsets.all(10.0)),
          ButtonWidget(
            title: 'Back',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
}

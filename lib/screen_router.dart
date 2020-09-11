import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/onboarding/onboarding.dart';
import 'package:gatabank/screens/private_loan/private_loan_cubit.dart';
import 'package:gatabank/screens/private_loan/private_loan_screen.dart';
import 'package:gatabank/screens/root.dart';
import 'package:gatabank/widgets/button_widget.dart';

class ScreenRouter {
  static const ROOT = '/';
  static const ONBOARDING = 'onboarding';
  static const PRIVATE_LOAN = 'private_loan';
  static const CREDIT_CARD = 'credit_card';
  static const INSURANCE = 'insurrance';

  UserRepository userRepos;

  ScreenRouter({this.userRepos});

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROOT:
        return MaterialPageRoute(
          builder: (context) => Root(
            userRepository: userRepos
          ),
          settings: settings,
        );
      case ONBOARDING:
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
          settings: settings,
        );
      case PRIVATE_LOAN:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<PrivateLoanCubit>(
            create: (context) {
              return PrivateLoanCubit();
            },
            child: PrivateLoanScreen(),
          ),
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

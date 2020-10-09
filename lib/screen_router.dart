import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/api.dart';
import 'package:gatabank/mocks/api.dart';
import 'package:gatabank/repositories/bank.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/comparison/comparision_cubit.dart';
import 'package:gatabank/screens/comparison/comparision_screen.dart';
import 'package:gatabank/screens/credit_card/credit_card_screen.dart';
import 'package:gatabank/screens/home/home_cubit.dart';
import 'package:gatabank/screens/insurance/insurance_screen.dart';
import 'package:gatabank/screens/loan_detail/loan_detail_cubit.dart';
import 'package:gatabank/screens/loan_detail/loan_detail_screen.dart';
import 'package:gatabank/screens/login/login_cubit.dart';
import 'package:gatabank/screens/onboarding/onboarding.dart';
import 'package:gatabank/screens/private_loan/private_loan_cubit.dart';
import 'package:gatabank/screens/private_loan/private_loan_screen.dart';
import 'package:gatabank/screens/root.dart';
import 'package:gatabank/screens/userinfo/userinfo.dart';
import 'package:gatabank/screens/userinfo/userinfo_bloc.dart';
import 'package:gatabank/widgets/button_widget.dart';

class ScreenRouter {
  static const ROOT = '/';
  static const ONBOARDING = 'onboarding';
  static const PRIVATE_LOAN = 'private_loan';
  static const CREDIT_CARD = 'credit_card';
  static const INSURANCE = 'insurrance';
  static const LOAN_DETAIL = 'loan_detail';
  static const USER_INFO = 'user_info';
  static const COMPARISION = 'comparision';

  var userRepo,
      bankRepo,
      authRepo;
  API api, mockAPI;

  ScreenRouter(){
    api = new API();
    mockAPI = new MockAPI();
    userRepo = UserRepository(api: mockAPI);
    bankRepo = BankRepository(api: mockAPI);
  }

  Function buildPageRoute(RouteSettings settings) {
    var blocProviders = [
      BlocProvider(create: (context) => LoginCubit(userRepo, AuthCubit(userRepo))),
      BlocProvider(create: (context) => LoanDetailCubit()),
      BlocProvider(create: (context) => PrivateLoanCubit(bankRepo)),
      BlocProvider(create: (context) => UserInfoCubit(userRepo)),
      BlocProvider(create: (context) => HomeCubit(userRepo)),
      BlocProvider(create: (context) => ComparisionCubit()),
      BlocProvider(create: (context) {
        var authCubit = AuthCubit(userRepo);
        authCubit.check();
        api.addErrorInterceptor((Exception error) {
          if (error is APIUnauthorizedException) {}
        });
        return authCubit;
      }),
    ];

    return (Widget builder) => MaterialPageRoute(
      builder: (context) =>
          MultiBlocProvider(providers: blocProviders, child: builder),
      settings: settings,
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    var route = buildPageRoute(settings);
    Map arguments = settings.arguments;

    switch (settings.name) {
      case ROOT:
        return route(Root());
      case ONBOARDING:
        return route(OnboardingScreen());
      case PRIVATE_LOAN:
        return route(PrivateLoanScreen());
      case LOAN_DETAIL:
        return route(LoanDetailScreen());
      case USER_INFO:
        return route(UserInfoScreen());
      case COMPARISION:
        return route(ComparisionScreen(banksList: arguments['banksList'], selectedBank: arguments['bank']));
      case INSURANCE:
        return route(InsuranceScreen());
      case CREDIT_CARD:
        return route(CreditCardScreen());
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

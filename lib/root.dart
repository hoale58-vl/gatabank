import 'package:devicelocale/devicelocale.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/screen_router.dart';
import 'package:gatabank/screens/common/home.dart';
import 'package:gatabank/screens/auth/login.dart';
import 'package:gatabank/services/api.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_states.dart';
import 'blocs/fcm/fcm_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/login/login_bloc.dart';
import 'config/config.dart';
import 'data/local/storage.dart';
import 'repositories/user_repos.dart';
import 'package:easy_localization/easy_localization.dart';

class Root extends StatefulWidget {
  final BaseUserRepository userRepository;
  final FirebaseAnalyticsObserver analyticsObserver;

  Root({Key key, this.userRepository, this.analyticsObserver}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    _setupFirstTimeLaunchApp();
    _initDynamicLinks();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          App.user = state.user;
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
            child: HomeScreen(widget.analyticsObserver),
          );
        }

        if (state is AuthenticationUnauthenticated) {
          App.user = null;
          _sendScreenViewToAnalytics(ScreenRouter.LOGIN);
          return BlocProvider<LoginBloc>(
            create: (context) {
              return LoginBloc(
                authBloc: BlocProvider.of<AuthBloc>(context),
                userRepository: widget.userRepository,
              );
            },
            child: LoginScreen(),
          );
        }

        return Container(color: Colors.white);
      },
    );
  }

  _setupFirstTimeLaunchApp() async {
    bool isFirstTimeLaunchApp = storage.isOnboardingEnabled();
    if (!isFirstTimeLaunchApp) return;
    await _setCurrentLocal();
    _goToOnBoarding();
  }

  Future _goToOnBoarding() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, ScreenRouter.ONBOARDING);
    });
    storage.disableOnboarding();
  }

  _setCurrentLocal() async {
    try {
      Locale currentLocale = await Devicelocale.currentAsLocale;
      context.locale = currentLocale.languageCode == 'id' ? Locale('id', 'ID') : Locale('en', 'US');
      utils.log(LocaleKeys.onboarding_next.tr()); // try on
    } catch (error) {
      utils.logError(content: "_setCurrentLocal() error $error");
      context.locale = Locale('en', 'US'); // fallback
    }
  }

  void _sendScreenViewToAnalytics(String screenName) {
    widget.analyticsObserver.analytics.setCurrentScreen(
      screenName: screenName,
    );
  }

  void _initDynamicLinks() async {
    final PendingDynamicLinkData dynamicLink = await FirebaseDynamicLinks.instance.getInitialLink();
    _setReferralCode(dynamicLink);
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      _setReferralCode(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  _setReferralCode(dynamicLink) {
    final Uri deepLink = dynamicLink?.link;
    if (deepLink == null) return;
    App.referralCode = deepLink.queryParameters['referral_code'];
  }
}

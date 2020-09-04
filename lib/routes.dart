import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gatabank/blocs/auth/auth_bloc.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/helpers/theme/theme_provider.dart';
import 'package:gatabank/helpers/theme/themes.dart';
import 'package:gatabank/screen_router.dart';
import 'package:easy_localization/easy_localization.dart';

class Routes extends StatelessWidget {
  final userRepos;

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver analyticsObserver =
  FirebaseAnalyticsObserver(analytics: analytics);

  const Routes(
      {Key key,
        this.userRepos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenRouter = ScreenRouter(
      userRepos: userRepos,
      authBloc: BlocProvider.of<AuthBloc>(context),
      analyticsObserver: analyticsObserver,
    );
    final Themes theme = Provider.of<ThemeProvider>(context).getTheme(context);
    App.theme = theme;

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          platform: TargetPlatform.iOS,
          backgroundColor: theme.colors.background,
          primaryColor: theme.colors.primary,
          accentColor: theme.colors.primary,
          buttonColor: theme.colors.primary,
          bottomAppBarColor: theme.colors.primary,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: App.theme.colors.bottomBar,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          appBarTheme: AppBarTheme(
            color: theme.colors.appBar,
            elevation: .5,
          ),
          unselectedWidgetColor: theme.colors.button3,
          // for checkbox
          fontFamily: 'Avenir',
          dividerTheme: DividerThemeData(thickness: 1, color: theme.colors.divider)),
      navigatorObservers: <NavigatorObserver>[analyticsObserver],
      onGenerateRoute: screenRouter.generateRoute,
      onUnknownRoute: screenRouter.unknownRoute,
      initialRoute: '/',
    );
  }
}

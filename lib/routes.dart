import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/config.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/theme/theme_provider.dart';
import 'package:gatabank/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:gatabank/screen_router.dart';

class Routes extends StatelessWidget {
  final userRepos;

  const Routes(
      {Key key,
        this.userRepos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenRouter = ScreenRouter(
      userRepos: userRepos,
      authCubit: BlocProvider.of<AuthCubit>(context),
    );
    final Themes theme = Provider.of<ThemeProvider>(context).getTheme(context);
    App.theme = theme;

    return MaterialApp(
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
      onGenerateRoute: screenRouter.generateRoute,
      onUnknownRoute: screenRouter.unknownRoute,
      initialRoute: '/',
    );
  }
}

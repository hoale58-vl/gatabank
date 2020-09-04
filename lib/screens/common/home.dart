import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gatabank/blocs/home/home_bloc.dart';
import 'package:gatabank/blocs/home/home_states.dart';
import 'package:gatabank/config/config.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:gatabank/helpers/theme/themes.dart';
import 'package:gatabank/packages/fab/fab_bottom_app_bar.dart';
import 'package:gatabank/screen_router.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen(this.observer);

  final FirebaseAnalyticsObserver observer;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _lastSelected;
  HomeBloc _homeBloc;

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _verificationNotifier.close();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeActiveTab) {
          setState(() {
            _lastSelected = state.index;
          });
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (context, state) {
          return _buildHomeScreen(context);
        },
      ),
    );
  }

  Scaffold _buildHomeScreen(BuildContext context) {
    Themes theme = App.theme;
    final TextStyle regularStyle = theme.styles.button3.copyWith(color: theme.colors.text7);
    final TextStyle selectedStyle = theme.styles.button4.copyWith(color: theme.colors.primary);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: _buildBody(context),
      bottomNavigationBar: FABBottomAppBar(
        backgroundColor: theme.colors.bottomBar,
        notchedShape: CircularNotchedRectangle(),
        initialSelectedIndex: _lastSelected,
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(
            text: LocaleKeys.home_home.tr(),
            normalImage: theme.getSvgPicture('home'),
            selectedImage: theme.getSvgPicture('home_selected'),
            regularStyle: regularStyle,
            selectedStyle: selectedStyle,
          ),
          FABBottomAppBarItem(
            text: LocaleKeys.home_event.tr(),
            normalImage: theme.getSvgPicture('event'),
            selectedImage: theme.getSvgPicture('event_selected'),
            regularStyle: regularStyle,
            selectedStyle: selectedStyle,
          ),
          FABBottomAppBarItem(
            text: LocaleKeys.home_program.tr(),
            normalImage: theme.getSvgPicture('program'),
            selectedImage: theme.getSvgPicture('program_selected'),
            regularStyle: regularStyle,
            selectedStyle: selectedStyle,
          ),
          FABBottomAppBarItem(
            text: LocaleKeys.home_settings.tr(),
            normalImage: theme.getSvgPicture('setting'),
            selectedImage: theme.getSvgPicture('setting_selected'),
            regularStyle: regularStyle,
            selectedStyle: selectedStyle,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: SvgPicture.asset('assets/center_focus_weak.svg'),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 2.0,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
      _sendCurrentTabToAnalytics();
    });
  }

  void _sendCurrentTabToAnalytics() {
    if (_lastSelected == null) return;

    var screenName = 'unknown';

    widget.observer.analytics.setCurrentScreen(screenName: "${ScreenRouter.ROOT}tab/$screenName");
  }
}

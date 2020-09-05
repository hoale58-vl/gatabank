import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_bloc.dart';
import 'home_states.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  {
  HomeBloc _homeBloc;
  int _lastSelected;

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
    return Scaffold();
  }
}
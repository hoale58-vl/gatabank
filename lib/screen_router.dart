import 'package:flutter/material.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/auth_bloc.dart';
import 'package:gatabank/screens/root.dart';
import 'package:gatabank/widgets/button_widget.dart';

class ScreenRouter {
  static const ROOT = '/';
  UserRepository userRepos;
  AuthBloc authBloc;

  ScreenRouter(
      {this.userRepos,
        this.authBloc});

  Route<dynamic> generateRoute(RouteSettings settings) {
    Map arguments = settings.arguments;

    switch (settings.name) {
      case ROOT:
        return MaterialPageRoute(
          builder: (context) => Root(
            userRepository: userRepos
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

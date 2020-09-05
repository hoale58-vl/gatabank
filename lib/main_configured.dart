import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/api.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/auth_bloc.dart';
import 'package:gatabank/screens/auth/auth_events.dart';
import 'package:gatabank/screens/auth/fcm_bloc.dart';
import 'package:gatabank/theme/theme_provider.dart';
import 'package:gatabank/utils.dart';
import 'package:provider/provider.dart';
import 'package:gatabank/routes.dart';
import 'package:provider/provider.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    utils.errorToast(error.toString());
  }
}

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZoned(() async {
    BlocSupervisor.delegate = SimpleBlocDelegate();
    var userRepos = UserRepository(api: api);

    await storage.init();

    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: BlocProvider<AuthBloc>(
          create: (context) {
            var authBloc =
            AuthBloc(userRepository: userRepos, fcmBloc: FcmBloc(userRepository: userRepos))
              ..add(AppStarted());

            api.onError((Exception error) {
              if (error is APIUnauthorizedException) {
                authBloc.add(LoggedOut());
              }
            });

            return authBloc;
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Routes(
                userRepos: userRepos),
          ),
        ),
      ),
    );
  });
}

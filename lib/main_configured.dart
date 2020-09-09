import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gatabank/api.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/auth/fcm_cubit.dart';
import 'package:gatabank/theme/theme_provider.dart';
import 'package:gatabank/Utils.dart';
import 'package:provider/provider.dart';
import 'package:gatabank/routes.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    Utils.errorToast(error.toString());
  }
}

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZoned(() async {
    Bloc.observer = SimpleBlocObserver();
    var userRepos = UserRepository(api: api);
    await storage.init();

    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: BlocProvider<AuthCubit>(
          create: (context) {
            var authBit = AuthCubit(userRepository: userRepos, fcmCubit: FcmCubit(userRepository: userRepos))
              ..checkAuthentication();

            api.onError((Exception error) {
              if (error is APIUnauthorizedException) {
                authBit.loggedOut();
              }
            });

            return authBit;
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

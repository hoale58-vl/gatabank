import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gatabank/blocs/fcm/fcm_bloc.dart';
import 'package:gatabank/data/local/storage.dart';
import 'package:gatabank/helpers/theme/theme_provider.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/repositories/user_repos.dart';
import 'package:gatabank/routes.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_events.dart';
import 'services/api.dart';

import 'helpers/lang/codegen_loader.g.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    utils.errorToast(error.toString());
  }
}

void mainDelegate() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  We have 2 environments, so it is okay to log crash to Firebase dev
  Crashlytics.instance.enableInDevMode = false;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() async {
    BlocSupervisor.delegate = SimpleBlocDelegate();
    var userRepos = UserRepository(api: api);

    await storage.init();

    runApp(
      EasyLocalization(
          supportedLocales: [Locale('vi', 'VN')],
          path: 'locales',
          fallbackLocale: Locale('vi', 'VN'),
          assetLoader: CodegenLoader(),
          child: ChangeNotifierProvider(
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
          )),
    );
  }, onError: Crashlytics.instance.recordError);
}

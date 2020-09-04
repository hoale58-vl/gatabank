import 'package:bloc/bloc.dart';
import 'package:gatabank/blocs/auth/auth_bloc.dart';
import 'package:gatabank/blocs/auth/auth_events.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gatabank/repositories/user_repos.dart';

import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BaseUserRepository userRepository;
  final AuthBloc authBloc;

  LoginBloc({this.userRepository, this.authBloc})
      : assert(userRepository != null),
        assert(authBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final user = await userRepository.authenticate(
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          yield LoginSuccess();
          authBloc.add(LoggedIn(user: user));
        } else {
          yield LoginFailure(error: LocaleKeys.error_user_not_found.tr());
        }
      } catch (error) {
        print(error);
        yield LoginFailure(error: LocaleKeys.error_user_not_found.tr());
      }
    }
  }
}

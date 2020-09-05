import 'package:bloc/bloc.dart';
import 'package:gatabank/models/user.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/fcm_bloc.dart';
import 'package:gatabank/screens/auth/fcm_events.dart';
import 'package:meta/meta.dart';

import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  static const PREF_LAST_BUILD_NUMBER = 'PREF_CURRENT_VERSION';

  final UserRepository userRepository;
  final FcmBloc fcmBloc;

  AuthBloc({@required this.userRepository, this.fcmBloc})
      : assert(userRepository != null && fcmBloc != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted) {
      User user = userRepository.currentUser();
      if (user != null) {
        yield AuthenticationAuthenticated(user: user);
      } else {
        yield AuthenticationUnauthenticated();
      }
    } else if (event is LoggedIn) {
      yield AuthenticationAuthenticated(user: event.user);
      fcmBloc.add(AddFcm());
    } else if (event is LoggedOut) {
      bool result = await userRepository.logout();
      if (result) {
        yield AuthenticationUnauthenticated();
        fcmBloc.add(RemoveFcm());
      } else {
        yield AuthenticationError();
      }
    }
  }
}

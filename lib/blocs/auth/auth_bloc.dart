import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gatabank/blocs/auth/auth_events.dart';
import 'package:gatabank/blocs/auth/auth_states.dart';
import 'package:gatabank/blocs/fcm/fcm_bloc.dart';
import 'package:gatabank/blocs/fcm/fcm_events.dart';
import 'package:gatabank/constants/const.dart';
import 'package:gatabank/data/local/storage.dart';
import 'package:gatabank/data/models/user.dart';
import 'package:gatabank/helpers/utils.dart';
import 'package:gatabank/repositories/user_repos.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  static const PREF_LAST_BUILD_NUMBER = 'PREF_CURRENT_VERSION';

  final BaseUserRepository userRepository;
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
        _handleAppUpgrade();
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

  _handleAppUpgrade() async {
    bool isAdded = await storage.getBoolean(CONST.PREF_IS_FCM_TOKEN_ADDED);
    int lastBuild = await storage.getInt(PREF_LAST_BUILD_NUMBER);
    if (isAdded) {
      if (lastBuild < 0) storage.saveInt(PREF_LAST_BUILD_NUMBER, await utils.getBuildNumber());
      return;
    }

    int currentBuild = await utils.getBuildNumber();
    if (lastBuild < currentBuild) {
      storage.saveInt(PREF_LAST_BUILD_NUMBER, currentBuild);
      fcmBloc.add(AddFcm());
    }
  }
}

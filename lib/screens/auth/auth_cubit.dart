import 'package:bloc/bloc.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/models/user.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:meta/meta.dart';

import 'auth_states.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  static const PREF_LAST_BUILD_NUMBER = 'PREF_CURRENT_VERSION';

  final UserRepository userRepository;

  AuthCubit(this.userRepository) : super(AuthenticationUninitialized());

  Future<void> check() async{
    User user = userRepository.currentUser();
    if (user != null) {
      emit(AuthenticationAuthenticated(user: user));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> loggedIn(User user) async {
    storage.saveUser(user);
    emit(AuthenticationAuthenticated(user: user));
  }

  Future<void> loggedOut() async {
    bool result = await userRepository.logout();
    if (result) {
      emit(AuthenticationUnauthenticated()) ;
    } else {
      emit(AuthenticationError());
    }
  }
}

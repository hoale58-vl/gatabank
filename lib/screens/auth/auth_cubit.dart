import 'package:bloc/bloc.dart';
import 'package:gatabank/models/user.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/fcm_cubit.dart';
import 'package:meta/meta.dart';

import 'auth_states.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  static const PREF_LAST_BUILD_NUMBER = 'PREF_CURRENT_VERSION';

  final UserRepository userRepository;
  final FcmCubit fcmCubit;

  AuthCubit({@required this.userRepository, @required this.fcmCubit}) : super(AuthenticationUninitialized());

  Future<void> checkAuthentication() async{
    User user = userRepository.currentUser();
    if (user != null) {
      emit(AuthenticationAuthenticated(user: user));
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }

  Future<void> loggedIn(User user) async {
    emit(AuthenticationAuthenticated(user: user));
    fcmCubit.addFcm();
  }

  Future<void> loggedOut() async {
    bool result = await userRepository.logout();
    if (result) {
      emit(AuthenticationUnauthenticated()) ;
      fcmCubit.removeFcm();
    } else {
      emit(AuthenticationError());
    }
  }
}

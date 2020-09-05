import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/user.dart';

import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc({this.userRepository})
      : assert(userRepository != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final user = await userRepository.sendOTP(
          phone: event.phone
        );

        if (user != null) {
          yield LoginSuccess();
        } else {
          yield LoginFailure();
        }
      } catch (error) {
        yield LoginFailure();
      }
    }
  }
}

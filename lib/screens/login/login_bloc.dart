import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/auth_bloc.dart';
import 'package:gatabank/screens/auth/auth_events.dart';

import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
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
        final result = await userRepository.sendOTP(
          phone: event.phone
        );

        if (result) {
          yield LoginSendingOtp(phone: event.phone);
        } else {
          yield LoginFailure();
        }
      } catch (error) {
        yield LoginFailure();
      }
    } else if (event is OtpButtonPressed){
      yield LoginLoading();
      try {
        final user = await userRepository.verifyOtp(
          phone: event.phone,
          otp: event.otp
        );

        if (user != null) {
          yield LoginSuccess();
          authBloc.add(LoggedIn(user: user));
        } else {
          yield LoginFailure();
        }
      } catch (error) {
        yield LoginFailure();
      }
    }
  }
}

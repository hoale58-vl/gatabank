import 'package:bloc/bloc.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gatabank/repositories/user_repos.dart';
import 'bloc.dart';

class ForgotPwdBloc extends Bloc<ForgotPwdEvent, ForgotPwdState> {
  final BaseUserRepository userRepository;
  ForgotPwdBloc({this.userRepository}) : assert(userRepository != null);

  @override
  ForgotPwdState get initialState => InitialForgotPwdState();

  @override
  Stream<ForgotPwdState> mapEventToState(ForgotPwdEvent event) async* {
    if (event is ForgotPwdCheckEmail) {
      yield ForgotPwdLoading();
      yield* _mapCheckEmailEventToState(event);
    }

    if (event is ForgotPwdSendEmail) {
      yield ForgotPwdLoading();
      yield* _mapSendEmailEventToState(event);
    }

    if (event is ForgotPwdCheckAuthenticationCode) {
      yield ForgotPwdLoading();
      yield* _mapCheckAuthenticationCodeToState(event);
    }

    if (event is ForgotPwdResetNewOne) {
      yield ForgotPwdLoading();

      if (event.newPassword != event.confirmNewPassword) {
        yield ForgotPwdFailed(error: LocaleKeys.error_password_does_not_match.tr());
      } else {
        yield* _mapResetPwdToState(event);
      }
    }
  }

  // check email valid or not
  Stream<ForgotPwdStatus> _mapCheckEmailEventToState(ForgotPwdCheckEmail event) async* {
    yield ForgotPwdStatus(value: await userRepository.checkEmailExist(email: event.email));
  }

  // send email with authentication code
  Stream<ForgotPwdSendAuthenticationCodeStatus> _mapSendEmailEventToState(
      ForgotPwdSendEmail event) async* {
    yield ForgotPwdSendAuthenticationCodeStatus(
        value: await userRepository.sendAuthenticationCodeForEmail(
            email: event.email, resend: event.resend));
  }

  // check authentication code and email
  Stream<ForgotPwdCheckAuthenticationCodeStatus> _mapCheckAuthenticationCodeToState(
      ForgotPwdCheckAuthenticationCode event) async* {
    yield ForgotPwdCheckAuthenticationCodeStatus(
        value: await userRepository.checkAuthenticationCodeAndEmail(
            email: event.email, authenticationCode: event.authenticationCode));
  }

  // reset new password
  Stream<ForgotPwdResetStatus> _mapResetPwdToState(ForgotPwdResetNewOne event) async* {
    yield ForgotPwdResetStatus(
        value: await userRepository.resetPwd(
            email: event.email,
            authenticationCode: event.authenticationCode,
            newPassword: event.newPassword,
            confirmNewPassword: event.confirmNewPassword));
  }
}

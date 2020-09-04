import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gatabank/blocs/user/user_events.dart';
import 'package:gatabank/blocs/user/user_states.dart';
import 'package:gatabank/repositories/user_repos.dart';
import 'package:gatabank/screens/account/verification_code.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final BaseUserRepository userRepository;

  UserBloc({@required this.userRepository}) : assert(userRepository != null);

  @override
  UserState get initialState => InitialUserState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield UserStateLoading();
    try {
      if (event is UserSendVerification) {
        bool isSuccess = false;
        String firebaseSID = '';
        if (event.verifyType == ValidationType.ForgotPassword) {
          isSuccess =
          await userRepository.sendAuthenticationCodeForEmail(email: event.email, resend: true);
        } else if (event.verifyType == ValidationType.VerificationPhone) {
          firebaseSID = await userRepository.sendOTP(
              recaptchaToken: event.recaptchaToken,
              phone: event.phone,
              countryCode: event.countryCode);
          isSuccess = (firebaseSID != null && firebaseSID.length > 0);
        } else {
          isSuccess = await userRepository.sendEmaiVerificationCode();
        }
        if (isSuccess)
          yield (UserSendVerificationSuccess(firebaseSID: firebaseSID));
        else
          throw Exception('Cannot send verification code');
      } else if (event is UserCheckVerification) {
        bool isSuccess = false;
        if (event.verifyType == ValidationType.ForgotPassword) {
          isSuccess = await userRepository.checkAuthenticationCodeAndEmail(
              email: event.email, authenticationCode: event.verificationCode);
        } else if (event.verifyType == ValidationType.VerificationPhone) {
          isSuccess = await userRepository.checkOTP(
              code: event.verificationCode, firebaseSID: event.firebaseSID);
        } else {
          isSuccess = await userRepository.checkEmailVerificationCode(code: event.verificationCode);
        }
        if (isSuccess)
          yield (UserCheckVerificationSuccess());
        else
          throw Exception('Invalid verification code');
      } else if (event is UserGetProfile) {
        yield UserGetSuccess(await userRepository.getUser());
      } else if (event is UserCheckPhoneNumber) {
        bool result = await userRepository.checkPhoneExist(
            countryCode: event.countryCode, phone: event.phone);
        yield UserCheckPhoneResult(result);
      }
    } catch (e) {
      yield UserStateFailed(e.toString());
    }
  }
}

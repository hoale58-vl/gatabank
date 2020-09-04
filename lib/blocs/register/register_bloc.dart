import 'package:bloc/bloc.dart';
import 'package:gatabank/blocs/auth/auth_bloc.dart';
import 'package:gatabank/blocs/register/register_events.dart';
import 'package:gatabank/helpers/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gatabank/repositories/user_repos.dart';
import 'package:gatabank/blocs/register/register_states.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final BaseUserRepository userRepository;
  final AuthBloc authBloc;

  RegisterBloc({this.userRepository, this.authBloc})
      : assert(userRepository != null),
        assert(authBloc != null);

  @override
  RegisterState get initialState => RegisterInitial();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterButtonPressed) {
      yield RegisterLoading();
      try {
        if (!event.isCheckTermAndAgreement) {
          yield RegisterFailure(error: LocaleKeys.error_please_accept_terms_of_use.tr());
        } else {
          if (event.password != event.confirmPassword) {
            yield RegisterFailure(error: LocaleKeys.error_please_double_check_your_password.tr());
          } else {
            final user = await userRepository.signup(
                email: event.email,
                password: event.password,
                confirmPassword: event.confirmPassword,
                referralCode: event.referralCode);
            yield user != null
                ? RegisterSuccess(user)
                : RegisterFailure(error:LocaleKeys.error_invalid_email_or_password.tr());
          }
        }
      } catch (error) {
        yield RegisterFailure(
            error: error.toString().contains(LocaleKeys.error_referral_code_is_invalid.tr())
                ? LocaleKeys.error_referral_code_is_invalid.tr()
                : LocaleKeys.error_invalid_email_or_password.tr());
      }
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/user.dart';
import 'userinfo_events.dart';
import 'userinfo_states.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UserRepository userRepository;

  UserInfoBloc({this.userRepository})
      : assert(userRepository != null);

  @override
  UserInfoState get initialState => UserInfoInitial();

  @override
  Stream<UserInfoState> mapEventToState(UserInfoEvent event) async* {
    yield UserInfoCreated();
    return;
  }
}

import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/user_repos.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;

  HomeBloc({this.userRepository})
      : assert(userRepository != null);

  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    yield HomeCreated();
    return;
  }
}

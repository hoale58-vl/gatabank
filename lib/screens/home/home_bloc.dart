import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/user.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;

  HomeCubit({this.userRepository}) : super(HomeInitial());
}

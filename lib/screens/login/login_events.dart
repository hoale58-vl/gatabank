import 'package:meta/meta.dart';

abstract class LoginEvent {
  LoginEvent() : super();
}

class LoginButtonPressed extends LoginEvent {
  final String phone;

  LoginButtonPressed({@required this.phone}) : super();

  @override
  String toString() => 'LoginButtonPressed { phone: $phone }';
}

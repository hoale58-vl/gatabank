import 'package:gatabank/models/user.dart';

abstract class AuthenticationEvent  {
  AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  final User user;

  LoggedIn({this.user});

  @override
  String toString() => 'LoggedIn: ${user.fullName}';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

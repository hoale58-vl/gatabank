import 'package:gatabank/models/user.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState  {
  AuthenticationState() : super();
}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticated extends AuthenticationState {
  final User user;

  AuthenticationAuthenticated({@required this.user});

  @override
  String toString() => 'AuthenticationAuthenticated $user';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationError extends AuthenticationState {
  @override
  String toString() => 'AuthenticationError';
}

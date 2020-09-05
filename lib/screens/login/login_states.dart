abstract class LoginState {
  LoginState() : super();
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginFailure extends LoginState {
  LoginFailure() : super();

  @override
  String toString() => 'LoginFailure';
}

class LoginSuccess extends LoginState {
  @override
  String toString() => 'LoginSuccess';
}

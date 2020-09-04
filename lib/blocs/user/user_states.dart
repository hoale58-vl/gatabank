import 'package:equatable/equatable.dart';
import 'package:gatabank/data/models/user.dart';

abstract class UserState extends Equatable {
  UserState([List props = const []]) : super([props]);
}

class InitialUserState extends UserState {
  @override
  String toString() => 'InitialUserState';
}

class UserStateLoading extends UserState {
  @override
  String toString() => 'UserLoading';
}

class UserGetSuccess extends UserState {
  final User user;

  UserGetSuccess(this.user);

  @override
  String toString() => 'UserGetSuccess';
}

class UserSendVerificationSuccess extends UserState {
  final firebaseSID;

  UserSendVerificationSuccess({this.firebaseSID});

  @override
  String toString() => 'UserSendVerificationSuccess';
}

class UserCheckVerificationSuccess extends UserState {
  @override
  String toString() => 'UserCheckVerificationSuccess';
}

class UserStateFailed extends UserState {
  final String error;

  UserStateFailed(this.error);

  @override
  String toString() => 'UserStateFailed';
}

class UserCheckPhoneResult extends UserState {
  final bool result;

  UserCheckPhoneResult(this.result);

  @override
  String toString() => 'UserCheckPhoneResult';
}
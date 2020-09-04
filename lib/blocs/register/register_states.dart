import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:gatabank/data/models/user.dart';

abstract class RegisterState extends Equatable {
  RegisterState([List props = const []]) : super([props]);
}

class RegisterInitial extends RegisterState {
  @override
  String toString() => 'RegisterInitial';
}

class RegisterLoading extends RegisterState {
  @override
  String toString() => 'RegisterLoading';
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({@required this.error}) : super([error]);

  @override
  String toString() => 'RegisterFailure { error: $error }';
}

class RegisterSuccess extends RegisterState {
  final User user;
  RegisterSuccess(this.user) : super([user]);

  @override
  String toString() => 'RegisterSuccess';
}

import 'package:flutter/cupertino.dart';
import 'package:gatabank/models/user.dart';

abstract class UserInfoState  {
  UserInfoState() : super();
}

class UserInfoInitial extends UserInfoState {
  @override
  String toString() => 'UserInfoInitial';
}

class UserInfoLoading extends UserInfoState {
  @override
  String toString() => 'UserInfoLoading';
}

class UpdateUserFailure extends UserInfoState {
  @override
  String toString() => 'UpdateUserFailure';
}

class UpdateUserSuccess extends UserInfoState {
  @override
  String toString() => 'UpdateUserSuccess';
}
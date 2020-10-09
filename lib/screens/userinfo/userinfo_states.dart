
import 'package:gatabank/models/user.dart';

abstract class UserInfoState  {
  UserInfoState() : super();
}

class UserInfoInitial extends UserInfoState {
  @override
  String toString() => 'UserInfoInitial';
}

class UserInfoLoaded extends UserInfoState {
  final User user;
  bool get submitBtnEnabled {
    return user.income != null && user.loanExpected != null && user.loanTerm != null && user.address != null && user.salaryReceiveMethod != null;
  }
  UserInfoLoaded(this.user);
  @override
  String toString() => 'UserInfoLoaded';
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

class ShowError extends UserInfoState {
  final String errorMsg;
  ShowError(this.errorMsg) : super();
  @override
  String toString() => 'ShowError';
}

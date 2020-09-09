
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

class UpdateIncome extends UserInfoState {
  final int income;
  UpdateIncome(this.income) : super();
  @override
  String toString() => 'UpdateIncome';
}

class UpdateLoanExpected extends UserInfoState {
  final int loanExpected;
  UpdateLoanExpected(this.loanExpected) : super();
  @override
  String toString() => 'UpdateLoanExpected';
}

class UpdateLoanTerm extends UserInfoState {
  final int loanTerm;
  UpdateLoanTerm(this.loanTerm) : super();
  @override
  String toString() => 'UpdateLoanTerm';
}

class UpdateAddress extends UserInfoState {
  final String address;
  UpdateAddress(this.address) : super();
  @override
  String toString() => 'UpdateAddress';
}

class UpdateSalaryReceiveMethod extends UserInfoState {
  final String salaryReceiveMethod;
  UpdateSalaryReceiveMethod(this.salaryReceiveMethod) : super();
  @override
  String toString() => 'UpdateSalaryReceiveMethod';
}

class ShowError extends UserInfoState {
  final String errorMsg;
  ShowError(this.errorMsg) : super();
  @override
  String toString() => 'ShowError';
}

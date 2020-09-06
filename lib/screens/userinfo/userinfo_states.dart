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

class UserInfoCreated extends UserInfoState {
  @override
  String toString() => 'UserInfoCreated';
}

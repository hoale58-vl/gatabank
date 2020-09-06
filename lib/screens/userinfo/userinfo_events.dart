abstract class UserInfoEvent  {
  UserInfoEvent() : super();
}

class UserInfoStarted extends UserInfoEvent {
  @override
  String toString() => 'UserInfoStarted';
}

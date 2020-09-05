abstract class HomeEvent  {
  HomeEvent() : super();
}

class HomeStarted extends HomeEvent {
  @override
  String toString() => 'HomeStarted';
}

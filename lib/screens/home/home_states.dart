abstract class HomeState  {
  HomeState() : super();
}

class HomeInitial extends HomeState {
  @override
  String toString() => 'HomeInitial';
}

class Navigate extends HomeState {
  String screen;

  Navigate(this.screen) ;

  @override
  String toString() => 'Navigate';
}

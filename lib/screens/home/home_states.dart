abstract class HomeState  {
  HomeState() : super();
}

class HomeInitial extends HomeState {
  @override
  String toString() => 'HomeInitial';
}

class HomeLoading extends HomeState {
  @override
  String toString() => 'HomeLoading';
}

class HomeActiveTab extends HomeState {
  final int index;

  HomeActiveTab({this.index}) : super();

  @override
  String toString() => 'HomeActiveTab $index';
}

class HomeCreated extends HomeState {
  @override
  String toString() => 'HomeCreated';
}

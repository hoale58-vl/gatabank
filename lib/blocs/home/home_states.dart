import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super([props]);
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

  HomeActiveTab({this.index}) : super([index]);

  @override
  String toString() => 'HomeActiveTab $index';
}

class HomeCreated extends HomeState {
  @override
  String toString() => 'HomeCreated';
}

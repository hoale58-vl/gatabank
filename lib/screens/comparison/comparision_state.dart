import 'package:gatabank/models/bank.dart';
import 'package:gatabank/screens/comparison/comparision_cubit.dart';

abstract class ComparisionState  {
  ComparisionState() : super();
}

class ComparisionInitial extends ComparisionState {
  @override
  String toString() => 'ComparisionInitial';
}

class ComparedBankRemoved extends ComparisionState {
  @override
  String toString() => 'ComparedBankRemoved';
}

class ComparedBankPicked extends ComparisionState {
  final Bank comparedBank;
  ComparedBankPicked(this.comparedBank);
  @override
  String toString() => 'ComparedBankPicked';
}
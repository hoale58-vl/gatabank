import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FcmState extends Equatable {
  FcmState([List props = const []]) : super([props]);
}

class FcmUninitialized extends FcmState {
  @override
  String toString() => 'FcmUninitialized';
}

class FcmTransactionConfirmed extends FcmState {
  final int transactionId;

  FcmTransactionConfirmed({@required this.transactionId}) : super([transactionId]);

  @override
  String toString() => 'FcmTransactionConfirmed $transactionId';
}

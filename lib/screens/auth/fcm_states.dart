import 'package:meta/meta.dart';

abstract class FcmState  {
  FcmState() : super();
}

class FcmUninitialized extends FcmState {
  @override
  String toString() => 'FcmUninitialized';
}

class FcmTransactionConfirmed extends FcmState {
  final int transactionId;

  FcmTransactionConfirmed({@required this.transactionId});

  @override
  String toString() => 'FcmTransactionConfirmed $transactionId';
}

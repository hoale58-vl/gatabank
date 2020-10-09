import 'package:gatabank/models/bank.dart';

abstract class PrivateLoanState  {
  PrivateLoanState() : super();
}

class PrivateLoanInitial extends PrivateLoanState {
  @override
  String toString() => 'PrivateLoanInitial';
}

class BankListLoading extends PrivateLoanState {
  @override
  String toString() => 'BankListLoading';
}

class BankListSuccess extends PrivateLoanState {
  final List<Bank> listBanks;
  BankListSuccess(this.listBanks);
  @override
  String toString() => 'PrivateLoanBankList size: ${listBanks.length}';
}

class BankListFailed extends PrivateLoanState {
  final String error;

  BankListFailed(this.error);
  @override
  String toString() => 'BankListFailed. Error: $error';
}

class UpdateFilterType extends PrivateLoanState {
  final String filterType;

  UpdateFilterType(this.filterType);
  @override
  String toString() => 'UpdateFilterType. filterType: $filterType';
}

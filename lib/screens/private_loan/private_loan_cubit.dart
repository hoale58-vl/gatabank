import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/bank.dart';
import 'package:gatabank/screens/private_loan/private_loan_states.dart';

class FilterType {
  static const PAYMENT_EACH_MONTH = "payment_each_month";
  static const TOTAL_PAYMENT = "total_payment";
  static const DISCOUNT = "discount";
  static const INTEREST = "interest";
}

class PrivateLoanCubit extends Cubit<PrivateLoanState> {
  BankRepository bankRepository;

  PrivateLoanCubit(
      this.bankRepository
      ) : super(PrivateLoanInitial());

  Future<void> getListBanks() async {
    try {
      emit(BankListLoading());
      final listTransaction = await bankRepository.list();
      emit(BankListSuccess(listTransaction));
    } catch (error) {
      emit(BankListFailed(error.toString()));
    }
  }

  Future<void> setFilter(String filterType) async {
    getListBanks();
  }
}

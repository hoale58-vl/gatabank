import 'package:bloc/bloc.dart';
import 'package:gatabank/models/bank.dart';
import 'comparision_state.dart';

class ComparisionCubit extends Cubit<ComparisionState> {
  List<Bank> banks;
  Bank comparedBank;

  ComparisionCubit() : super(ComparisionInitial());

  Future<void> removeComparedBank() async {
    comparedBank = null;
    emit(ComparedBankRemoved());
  }

  Future<void> addComparedBank(Bank bank) async {
    comparedBank = bank;
    emit(ComparedBankPicked(bank));
  }
}

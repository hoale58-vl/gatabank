import 'package:bloc/bloc.dart';
import 'package:gatabank/screens/loan_detail/loan_detail_states.dart';

class LoanDetailCubit extends Cubit<LoanDetailState> {

  LoanDetailCubit() : super(LoanDetailInitial());
}

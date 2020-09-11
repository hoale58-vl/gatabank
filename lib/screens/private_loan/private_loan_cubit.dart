import 'package:bloc/bloc.dart';
import 'package:gatabank/screens/private_loan/private_loan_states.dart';

class PrivateLoanCubit extends Cubit<PrivateLoanState> {

  PrivateLoanCubit() : super(PrivateLoanInitial());
}

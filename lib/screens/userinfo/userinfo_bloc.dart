
import 'package:bloc/bloc.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/models/user.dart';
import 'package:gatabank/repositories/user.dart';
import 'userinfo_states.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final UserRepository userRepository;
  User user;
  UserInfoCubit(this.userRepository) : super(UserInfoInitial());

  Future<void> loadUser() async {
    emit(UserInfoLoading());
    user = storage.getUser();
    emit(UserInfoLoaded(user));
  }

  Future<void> updateIncome(String income) async {
    final result = int.tryParse(income);
    user.income = result;
    if (result == null){
      emit(ShowError("Mức thu nhập không hợp lệ"));
    }
    emit(UserInfoLoaded(user));
  }

  Future<void> updateLoanExpected(String loanExpected) async {
    final result = int.tryParse(loanExpected);
    user.loanExpected = result;
    if (result == null){
      emit(ShowError("Khoảng vay không hợp lệ"));
    }
    emit(UserInfoLoaded(user));
  }

  Future<void> updateLoanTerm(int loanTerm) async {
    user.loanTerm = loanTerm;
    emit(UserInfoLoaded(user));
  }

  Future<void> updateAddress(String address) async {
    user.address = address;
    if (address == null || address.isEmpty){
      emit(ShowError("Địa chỉ không được để trống"));
    }
    emit(UserInfoLoaded(user));
  }

  Future<void> updateSalaryReceiveMethod(String salaryReceiveMethod) async {
    user.salaryReceiveMethod = salaryReceiveMethod;
    if (salaryReceiveMethod == null || salaryReceiveMethod.isEmpty){
      emit(ShowError("Phương thức thanh toán không được để trống"));
    }
    emit(UserInfoLoaded(user));
  }

  Future<void> submitData() async {
    emit(UserInfoLoading());
    try {
      final _user = await userRepository.updateInfo(
          income: user.income,
          loanExpected: user.loanExpected,
          loanTerm: user.loanTerm,
          address: user.address,
          salaryReceiveMethod: user.salaryReceiveMethod
      );

      if (_user != null) {
        storage.saveUser(_user);
        emit(UpdateUserSuccess());
      } else {
        emit(UpdateUserFailure());
        emit(UserInfoLoaded(user));
      }
    } catch (error) {
      emit(UpdateUserFailure());
      emit(UserInfoLoaded(user));
    }
  }

  Future<void> resetForm() async {
    user.income = null;
    user.loanExpected = null;
    user.loanTerm = null;
    user.address = null;
    user.salaryReceiveMethod = null;
    emit(UserInfoLoaded(user));
  }
}

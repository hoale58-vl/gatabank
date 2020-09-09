import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'userinfo_states.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final UserRepository userRepository;

  UserInfoCubit({@required this.userRepository}) : super(UserInfoInitial());

  Future<void> updateIncome(String income) async {
    final result = int.tryParse(income);
    emit(UpdateIncome(result));
    if (result == null){
      emit(ShowError("Mức thu nhập không hợp lệ"));
    }
  }

  Future<void> updateLoanExpected(String loanExpected) async {
    final result = int.tryParse(loanExpected);
    emit(UpdateLoanExpected(result));
    if (result == null){
      emit(ShowError("Khoảng vay không hợp lệ"));
    }
  }

  Future<void> updateLoanTerm(String loanTerm) async {
    final result = int.tryParse(loanTerm);
    emit(UpdateLoanTerm(result));
    if (result == null){
      emit(ShowError("Thời hạn vay không được để trống"));
    }
  }

  Future<void> updateAddress(String address) async {
    emit(UpdateAddress(address));
    if (address == null || address.isEmpty){
      emit(ShowError("Địa chỉ không được để trống"));
    }
  }

  Future<void> updateSalaryReceiveMethod(String salaryReceiveMethod) async {
    emit(UpdateSalaryReceiveMethod(salaryReceiveMethod));
    if (salaryReceiveMethod == null || salaryReceiveMethod.isEmpty){
      emit(ShowError("Phương thức thanh toán không được để trống"));
    }
  }

  Future<void> submitData({
    @required int income,
    @required int loanExpected,
    @required int loanTerm,
    @required String address,
    @required String salaryReceiveMethod
  }) async {
    emit(UserInfoLoading());
    try {
      final user = await userRepository.updateInfo(
          income: income,
          loanExpected: loanExpected,
          loanTerm: loanTerm,
          address: address,
          salaryReceiveMethod: salaryReceiveMethod
      );

      if (user != null) {
        storage.saveUser(user);
        emit(UpdateUserSuccess());
      } else {
        emit(UpdateUserFailure());
      }
    } catch (error) {
      emit(UpdateUserFailure());
    }
  }
}

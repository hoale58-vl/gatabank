import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gatabank/models/storage.dart';
import 'package:gatabank/repositories/user.dart';
import 'userinfo_states.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final UserRepository userRepository;

  UserInfoCubit({@required this.userRepository}) : super(UserInfoInitial());

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

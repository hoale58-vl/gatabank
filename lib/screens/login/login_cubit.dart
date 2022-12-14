import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gatabank/repositories/user.dart';
import 'package:gatabank/screens/auth/auth_cubit.dart';
import 'package:gatabank/screens/auth/auth_states.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository userRepository;
  final AuthCubit authCubit;

  LoginCubit(this.userRepository, this.authCubit) : super(LoginInitial());
  
  Future<void> sendOtp(String phone) async {
    emit(LoginLoading());
    try {
      final result = await userRepository.sendOTP(phone);
      if (result) {
        emit(LoginSendingOtp(phone: phone)) ;
      } else {
        emit(LoginFailure());
      }
    } catch (error) {
      print(error);
      emit(LoginFailure());
    }
  }

  Future<void> login(String phone, String otp) async {
    emit(LoginLoading());
    try {
      final user = await userRepository.verifyOtp(phone,otp);
      if (user != null) {
        emit(LoginSuccess());
        authCubit.loggedIn(user);
      } else {
        emit(LoginFailure());
      }
    } catch (error) {
      emit(LoginFailure());
    }
  }

}

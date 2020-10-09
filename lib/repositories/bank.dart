import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gatabank/api.dart';
import 'package:gatabank/mocks/api.dart';
import 'package:gatabank/mocks/data.dart';
import 'package:gatabank/models/bank.dart';
import 'package:mockito/mockito.dart';

class BankRepository {
  final API api;
  BankRepository({
    @required this.api,
  })  : assert(api != null){
    if (api is MockAPI){
      when(api.listBanks()).thenAnswer(successResponse(BankMockData.list()));
    }
  }

  Future<List<Bank>> list() async {
    var response = await api.listBanks();
    if (response.statusCode != HttpStatus.ok) return null;

    Map<String, dynamic> map = response.data;
    List<dynamic> bankList = map['data'];

    if (bankList == null) return null;

    List<Bank> _bankList = List();
    for (Map<String, dynamic> bank in bankList) {
      _bankList.add(Bank.fromJson(bank));
    }
    return _bankList;
  }
}
import 'package:meta/meta.dart';

class User {
  String id;
  String fullName;
  String phone;
  int income;
  int loanExpected;
  int loanTerm;
  String address;
  String salaryReceiveMethod;

  User(
      {
        this.id,
        this.fullName,
        @required this.phone,
        this.income,
        this.loanExpected,
        this.loanTerm,
        this.address,
        this.salaryReceiveMethod
      });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'income': income,
      'loan_expected': loanExpected,
      'loan_term': loanTerm,
      'address': address,
      'salary_receive_method': salaryReceiveMethod
    };
    return map;
  }

  get fullPhoneNumber => '+84$phone';

  User.fromJson(Map<String, dynamic> map) {
    id = map['id'] as String;
    fullName = map['full_name'] as String;
    phone = map['phone'] as String;
    income = map['income'] as int;
    loanExpected = map['loan_expected'] as int;
    loanTerm = map['loan_term'] as int;
    address = map['address'] as String;
    salaryReceiveMethod = map['salary_receive_method'] as String;
  }

  @override
  String toString() {
    return ('id: ${this.id} - full name: ${this.fullName}');
  }

  bool updatedInfo(){
    return income != null
        && loanExpected != null
        && loanTerm != null
        && address != null
        && salaryReceiveMethod != null;
  }
}

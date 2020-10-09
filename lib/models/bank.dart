import 'package:meta/meta.dart';

class BankRequirement {
  String age;
  String personalIdentifier;
  String incomeIdentifier;
  String homeIdentifier;
  String other;

  static const AGE = 'age';
  static const PERSONAL_IDENTIFIER = 'personalIdentifier';
  static const INCOME_IDENTIFIER = 'incomeIdentifier';
  static const HOME_IDENTIFIER = 'homeIdentifier';
  static const OTHER = 'other';

  BankRequirement({
    this.age,
    this.personalIdentifier,
    this.incomeIdentifier,
    this.homeIdentifier,
    this.other
  });

  BankRequirement.fromMap(Map<String, dynamic> map){
    age = map[AGE] as String;
    personalIdentifier = map[PERSONAL_IDENTIFIER] as String;
    incomeIdentifier = map[INCOME_IDENTIFIER] as String;
    homeIdentifier = map[HOME_IDENTIFIER] as String;
    other = map[OTHER] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      AGE: age,
      PERSONAL_IDENTIFIER: personalIdentifier,
      INCOME_IDENTIFIER: incomeIdentifier,
      HOME_IDENTIFIER: homeIdentifier,
    };
    return map;
  }
}

class BankFee {
  String penaltyInterest;
  String penaltyFee;
  String earlierPaymentFee;

  static const PENALTY_INTEREST = 'penaltyInterest';
  static const PENALTY_FEE = 'penaltyFee';
  static const EARLIER_PAYMENT_FEE = 'earlier_payment_fee';

  BankFee({
    this.penaltyFee,
    this.penaltyInterest,
    this.earlierPaymentFee
  });

  BankFee.fromMap(Map<String, dynamic> map){
    penaltyFee = map[PENALTY_FEE] as String;
    penaltyInterest = map[PENALTY_INTEREST] as String;
    earlierPaymentFee = map[EARLIER_PAYMENT_FEE] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      PENALTY_FEE: penaltyFee,
      PENALTY_INTEREST: penaltyInterest,
      EARLIER_PAYMENT_FEE: earlierPaymentFee,
    };
    return map;
  }
}

class BankDiscount {
  static const ID = 'id';
  static const LABEL = 'label';
  static const DESCRIPTION = 'description';

  String id;
  String label;
  String description;

  BankDiscount(
      {
        this.id,
        this.label,
        this.description
      });

  BankDiscount.fromMap(Map<String, dynamic> map){
    id = map[ID] as String;
    label = map[LABEL] as String;
    description = map[DESCRIPTION] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      ID: id,
      LABEL: label,
      DESCRIPTION: description,
    };
    return map;
  }
}

class Bank {
  static const ID = 'id';
  static const NAME = 'name';
  static const IMAGE = 'image';
  static const MIN_LOAN_AMOUNT = 'min_loan_amount';
  static const MAX_LOAN_AMOUNT = 'max_loan_amount';
  static const INTEREST_PERCENTAGE = 'interest_percentage';
  static const INTEREST_TYPE = 'interest_type';
  static const MIN_INCOME = 'min_income';
  static const MIN_LOAN_TERM = 'min_loan_term';
  static const MAX_LOAN_TERM = 'max_loan_term';
  static const VERIFIED_IN = 'verified_in';
  static const INTEREST_CAL_METHOD = 'interest_cal_method';
  static const REQUIREMENT = 'requirement';
  static const DISCOUNTS = 'discounts';
  static const BANK_FEE = 'bankFee';

  String id;
  String name;
  String image;
  int minLoanAmount;
  int maxLoanAmount;
  int interestPercentage;
  String interestType;
  int minIncome;
  String minLoanTerm;
  String maxLoanTerm;
  String verifiedIn;
  String interestCalMethod;
  BankRequirement requirement;
  List<BankDiscount> discounts;
  BankFee bankFee;

  Bank(
      {
        this.id,
        @required this.name,
        this.image,
        this.minLoanAmount,
        this.maxLoanAmount,
        this.interestPercentage,
        this.interestType,
        this.minIncome,
        this.minLoanTerm,
        this.maxLoanTerm,
        this.verifiedIn,
        this.interestCalMethod,
        this.requirement,
        this.discounts,
        this.bankFee
      });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      ID: id,
      NAME: name,
      IMAGE: image,
      MIN_LOAN_AMOUNT: minLoanAmount,
      MAX_LOAN_AMOUNT: maxLoanAmount,
      INTEREST_PERCENTAGE: interestPercentage,
      INTEREST_TYPE: interestType,
      MIN_INCOME: minIncome,
      MIN_LOAN_TERM: minLoanTerm,
      MAX_LOAN_TERM: maxLoanTerm,
      VERIFIED_IN: verifiedIn,
      INTEREST_CAL_METHOD: interestCalMethod,
      REQUIREMENT: requirement.toJson(),
      DISCOUNTS: discounts.map((e) => e.toJson()).toList(),
      BANK_FEE: bankFee.toJson()
    };
    return map;
  }

  Bank.fromJson(Map<String, dynamic> map) {
    id = map[ID] as String;
    name = map[NAME] as String;
    image = map[IMAGE] as String;
    minLoanAmount = map[MIN_LOAN_AMOUNT] as int;
    maxLoanAmount = map[MAX_LOAN_AMOUNT] as int;
    interestPercentage = map[INTEREST_PERCENTAGE] as int;
    interestType = map[INTEREST_TYPE] as String;
    interestCalMethod = map[INTEREST_CAL_METHOD] as String;
    minIncome = map[MIN_INCOME] as int;
    minLoanTerm = map[MIN_LOAN_TERM] as String;
    maxLoanTerm = map[MAX_LOAN_TERM] as String;
    verifiedIn = map[VERIFIED_IN] as String;
    requirement = map[REQUIREMENT] != null ? BankRequirement.fromMap(map[REQUIREMENT]) : null;
    discounts = map[DISCOUNTS] != null ? (map[DISCOUNTS] as List).map((discount) => BankDiscount.fromMap(discount)).toList() : [];
    bankFee = map[BANK_FEE] != null ? BankFee.fromMap(map[BANK_FEE]) : null;
  }

  @override
  String toString() {
    return ('id: ${this.id} - name: ${this.name}');
  }

}

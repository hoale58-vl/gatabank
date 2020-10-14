import 'package:meta/meta.dart';

class CardDiscount {
  static const ID = 'id';
  static const LABEL = 'label';
  static const DESCRIPTION = 'description';

  String id;
  String label;
  String description;

  CardDiscount(
      {
        this.id,
        this.label,
        this.description
      });

  CardDiscount.fromMap(Map<String, dynamic> map){
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

class CardBenefit {
  static const ID = 'id';
  static const LABEL = 'label';
  static const DESCRIPTION = 'description';

  String id;
  String label;
  String description;

  CardBenefit(
      {
        this.id,
        this.label,
        this.description
      });

  CardBenefit.fromMap(Map<String, dynamic> map){
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

class CardRequirement {
  int age;
  String personalIdentifier;
  int incomeRequirement;
  String homeIdentifier;

  static const AGE = 'age';
  static const PERSONAL_IDENTIFIER = 'personalIdentifier';
  static const INCOME_REQUIREMENT = 'incomeRequirement';
  static const HOME_IDENTIFIER = 'homeIdentifier';

  CardRequirement({
    this.age,
    this.personalIdentifier,
    this.incomeRequirement,
    this.homeIdentifier,
  });

  CardRequirement.fromMap(Map<String, dynamic> map){
    age = map[AGE] as int;
    personalIdentifier = map[PERSONAL_IDENTIFIER] as String;
    incomeRequirement = map[INCOME_REQUIREMENT] as int;
    homeIdentifier = map[HOME_IDENTIFIER] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      AGE: age,
      PERSONAL_IDENTIFIER: personalIdentifier,
      INCOME_REQUIREMENT: incomeRequirement,
      HOME_IDENTIFIER: homeIdentifier,
    };
    return map;
  }
}

class CardFee {
  String cashAdvance;
  String latePayment;
  String foreignTransaction;

  static const CASH_ADVANCE = 'cashAdvance';
  static const LATE_PAYMENT = 'latePayment';
  static const FOREIGN_TRANSACTION = 'foreignTransaction';

  CardFee({
    this.cashAdvance,
    this.latePayment,
    this.foreignTransaction,
  });

  CardFee.fromMap(Map<String, dynamic> map){
    cashAdvance = map[CASH_ADVANCE] as String;
    latePayment = map[LATE_PAYMENT] as String;
    foreignTransaction = map[FOREIGN_TRANSACTION] as String;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      CASH_ADVANCE: cashAdvance,
      LATE_PAYMENT: latePayment,
      FOREIGN_TRANSACTION: foreignTransaction,
    };
    return map;
  }
}

class CardBasic {
  int freeAirportLounge;
  int yearlyFee;
  int averageRefund;
  int maxRefund;
  String cardOrg;
  int interest;
  int issueFee;
  int interestFreeDay;
  int paymentEachMonth;

  static const FREE_AIRPORT_LOUNGE = 'freeAirportLounge';
  static const YEARLY_FEE = 'yearlyFee';
  static const AVERAGE_REFUND = 'averageRefund';
  static const MAX_REFUND = 'maxRefund';
  static const CARD_ORG = 'cardOrg';
  static const INTEREST = 'interest';
  static const ISSUE_FEE = 'issueFee';
  static const INTEREST_FREE_DAY = 'interestFreeDay';
  static const PAYMENT_EACH_MONTH = 'paymentEachMonth';

  CardBasic({
    this.freeAirportLounge,
    this.yearlyFee,
    this.averageRefund,
    this.maxRefund,
    this.cardOrg,
    this.interest,
    this.issueFee,
    this.interestFreeDay,
    this.paymentEachMonth,
  });

  CardBasic.fromMap(Map<String, dynamic> map){
    freeAirportLounge = map[FREE_AIRPORT_LOUNGE] as int;
    yearlyFee = map[YEARLY_FEE] as int;
    averageRefund = map[AVERAGE_REFUND] as int;
    maxRefund = map[MAX_REFUND] as int;
    cardOrg = map[CARD_ORG] as String;
    interest = map[INTEREST] as int;
    issueFee = map[ISSUE_FEE] as int;
    interestFreeDay = map[INTEREST_FREE_DAY] as int;
    paymentEachMonth = map[PAYMENT_EACH_MONTH] as int;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      FREE_AIRPORT_LOUNGE: freeAirportLounge,
      YEARLY_FEE: yearlyFee,
      AVERAGE_REFUND: averageRefund,
      MAX_REFUND: maxRefund,
      CARD_ORG: cardOrg,
      INTEREST: interest,
      ISSUE_FEE: issueFee,
      INTEREST_FREE_DAY: interestFreeDay,
      PAYMENT_EACH_MONTH: paymentEachMonth,
    };
    return map;
  }
}

class Card {
  static const ID = 'id';
  static const NAME = 'name';
  static const SPONSOR = 'sponsor';
  static const SUBTITLE = 'subtitle';
  static const RATING = 'rating';
  static const CARD_DISCOUNTS = 'cardDiscounts';
  static const CARD_BENEFITS = 'cardBenefits';
  static const CARD_REQUIREMENT = 'cardRequirement';
  static const CARD_FEE = 'cardFee';
  static const CARD_BASIC = 'cardBasic';
  static const IMAGE = 'image';


  String id;
  String name;
  String sponsor;
  String subtitle;
  double rating;
  List<CardDiscount> cardDiscounts;
  List<CardBenefit> cardBenefits;
  CardRequirement cardRequirement;
  CardFee cardFee;
  CardBasic cardBasic;
  String image;


  Card(
      {
        this.id,
        @required this.name,
        this.sponsor,
        this.subtitle,
        this.rating,
        this.cardBasic,
        this.cardBenefits,
        this.cardDiscounts,
        this.cardFee,
        this.cardRequirement,
        this.image

      });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      ID: id,
      NAME: name,
      SPONSOR: sponsor,
      SUBTITLE: subtitle,
      RATING: rating,
      CARD_BASIC: cardBasic,
      CARD_BENEFITS: cardBenefits,
      CARD_DISCOUNTS: cardDiscounts,
      CARD_FEE: cardFee,
      CARD_REQUIREMENT: cardRequirement,
      IMAGE: image

    };
    return map;
  }

  Card.fromJson(Map<String, dynamic> map) {
    id = map[ID] as String;
    name = map[NAME] as String;
    sponsor = map[SPONSOR] as String;
    subtitle = map[SUBTITLE] as String;
    rating = map[RATING] as double;
    cardFee = CardFee.fromMap(map[CARD_FEE]);
    cardRequirement = CardRequirement.fromMap(map[CARD_REQUIREMENT]);
    cardDiscounts = (map[CARD_DISCOUNTS] as List).map((e) => CardDiscount.fromMap(e)).toList();
    cardBenefits = (map[CARD_BENEFITS] as List).map((e) => CardBenefit.fromMap(e)).toList();
    cardBasic = CardBasic.fromMap(map[CARD_BASIC]);
    image = map[IMAGE] as String;
  }

  @override
  String toString() {
    return ('id: ${this.id} - name: ${this.name}');
  }

}

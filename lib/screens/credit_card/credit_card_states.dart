import 'package:gatabank/models/card.dart';

abstract class CreditCardState  {
  CreditCardState() : super();
}

class CreditCardInitial extends CreditCardState {
  @override
  String toString() => 'CreditCardInitial';
}

class CardListLoading extends CreditCardState {
  @override
  String toString() => 'CardListLoading';
}

class CardListSuccess extends CreditCardState {
  final List<Card> listCards;
  CardListSuccess(this.listCards);
  @override
  String toString() => 'CardListSuccess size: ${listCards.length}';
}

class CardListFailed extends CreditCardState {
  final String error;

  CardListFailed(this.error);
  @override
  String toString() => 'CardListFailed. Error: $error';
}

class UpdateFilterCardType extends CreditCardState {
  final String filterType;

  UpdateFilterCardType(this.filterType);
  @override
  String toString() => 'UpdateFilterCardType. filterType: $filterType';
}

class UpdateFilterDiscount extends CreditCardState {
  final String filterType;

  UpdateFilterDiscount(this.filterType);
  @override
  String toString() => 'UpdateFilterDiscount. filterType: $filterType';
}

class UpdateFilterOrderBy extends CreditCardState {
  final String filterType;

  UpdateFilterOrderBy(this.filterType);
  @override
  String toString() => 'UpdateFilterOrderBy. filterType: $filterType';
}

class UpdateFilterCalTool extends CreditCardState {
  final String filterType;

  UpdateFilterCalTool(this.filterType);
  @override
  String toString() => 'UpdateFilterCalTool. filterType: $filterType';
}
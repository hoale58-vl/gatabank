import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gatabank/api.dart';
import 'package:gatabank/mocks/api.dart';
import 'package:gatabank/mocks/data.dart';
import 'package:gatabank/models/card.dart';
import 'package:mockito/mockito.dart';

class CardRepository {
  final API api;
  CardRepository({
    @required this.api,
  })  : assert(api != null){
    if (api is MockAPI){
      when(api.listCards(
          cardType: anyNamed("cardType"),
          discount: anyNamed("discount"),
          order: anyNamed("order"),
          calTool: anyNamed("calTool"))).thenAnswer(successResponse(CardMockData.list()));
    }
  }

  Future<List<Card >> list({cardType, discount, order, calTool}) async {
    var response = await api.listCards(cardType: cardType, discount: discount, order: order, calTool: calTool);
    if (response.statusCode != HttpStatus.ok) return null;

    Map<String, dynamic> map = response.data;
    List<dynamic> cardList = map['data'];

    if (cardList == null) return null;

    List<Card> _cardList = List();
    for (Map<String, dynamic> card in cardList) {
      _cardList.add(Card.fromJson(card));
    }
    return _cardList;
  }
}
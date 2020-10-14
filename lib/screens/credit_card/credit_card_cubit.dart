import 'package:bloc/bloc.dart';
import 'package:gatabank/repositories/card.dart';
import 'package:gatabank/screens/credit_card/credit_card_states.dart';

class FilterCardType {
  static const VISA = "VISA";
  static const AMEX = "AMEX";
  static const MasterCard = "MasterCard";
  static const UnionPay = "UnionPay";
  static const JCB = "JCB";
}

class FilterDiscount {
  static const PRICE_REDUCE = "priceReduce";
  static const REFUND_AND_GIFT = "refundAndGift";
  static const YEARLY_FEE_FREE_AND_GIRFT = "yearlyFeeFreeAndGift";
  static const HIGH_QUALITY_GIFT = "highQualityGift";
  static const ZERO_INSTALLMENT = "zeroInstallment";
}

class FilterOrderBy {
  static const DISCOUNT = "discount";
  static const RATING = "rating";
}

class FilterCalTool {
  static const REFUND = "refund";
  static const DISTANCE = "distance";
}

class CreditCardCubit extends Cubit<CreditCardState> {
  CardRepository cardRepository;

  CreditCardCubit(
      this.cardRepository
      ) : super(CreditCardInitial());

  Future<void> getListCards({cardType, discount, order, calTool}) async {
    try {
      emit(CardListLoading());
      final listTransaction = await cardRepository.list(cardType: cardType, discount: discount, order: order, calTool: calTool);
      emit(CardListSuccess(listTransaction));
    } catch (error) {
      emit(CardListFailed(error.toString()));
    }
  }
}

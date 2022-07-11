import '../app_enums/EnumClasses.dart';
import '../app_strings/AppStrings.dart';

class PaymentModel {
  final String amount;

  final String currencyCode;

  final String customerName;

  final String customerEmail;
  final String paymentReference;

  final String paymentDescription;
  final PaymentMethod paymentMethod;

  PaymentModel(
      {required this.amount,
      required this.currencyCode,
      required this.customerName,
      required this.paymentDescription,
      required this.paymentReference,
      required this.customerEmail,
      required this.paymentMethod});

  Map<String, String> toMap() {
    final map = {
      AppStrings.amounToPayKey: amount,
      AppStrings.currencyCodeKey: currencyCode,
      AppStrings.customerNameKey: customerName,
      AppStrings.customerEmailKey: customerEmail,
      AppStrings.paymentReferenceKey: paymentReference,
      AppStrings.paymentDescriptionKey: paymentDescription,
      AppStrings.paymentMethodKey: _paymentMethod(paymentMethod)
    };
    return map;
  }

  String _paymentMethod(PaymentMethod method) => method == PaymentMethod.card
      ? AppStrings.paymentMethodCardValue
      : method == PaymentMethod.accountTransfer
          ? AppStrings.paymentMethodBankTransferValue
          : AppStrings.paymentMethodAllValue;
}

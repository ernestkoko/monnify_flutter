import '../app_enums/EnumClasses.dart';
import '../app_strings/AppStrings.dart';

/// Class for accepting the result of transactions from the platforms
class Transaction {
  final String message;
  final PaymentStatus status;
  final String amount;
  final String amountPayable;
  final String date;
  final String method;
  final String transactionReference;
  final String currencyCode;
  final String customerName;
  final String customerEmail;
  final String paymentReference;
  final String paymentDescription;

  Transaction(
      {required this.amount,
      required this.currencyCode,
      required this.customerName,
      required this.paymentDescription,
      required this.paymentReference,
      required this.customerEmail,
      required this.amountPayable,
      required this.date,
      required this.message,
      required this.method,
      required this.status,
      required this.transactionReference});

  ///This returns an object of this class
  /// It takes in a Map [map] as argument
  Transaction.fromMap(Map<String, dynamic> map)
      : message = map[AppStrings.paidStatusMessageKey] ?? "",
        transactionReference =
            map[AppStrings.paidTransactionReferenceKey] ?? "",
        status = _setTransactionStatus(map[AppStrings.paidStatusMessageKey]),
        method = map[AppStrings.paidPaymentMethodKey] ?? "",
        date = map[AppStrings.paidDateKey] ?? "",
        amountPayable = map[AppStrings.paidAmountPayableKey] ?? "",
        customerEmail = map[AppStrings.paidCustomerEmailKey] ?? "",
        paymentReference = map[AppStrings.paidPaymentReferenceKey] ?? "",
        paymentDescription = map[AppStrings.paidPaymentDescriptionkey] ?? "",
        customerName = map[AppStrings.paidCustomerNameKey] ?? "",
        currencyCode = map[AppStrings.paidCurrencyCodeKey] ?? "",
        amount = map[AppStrings.paidAmountKey] ?? "";

  /// [_setTransactionStatus] returns [PaymentStatus] and accepts String
  /// [statusMessage] as an argument
  static PaymentStatus _setTransactionStatus(String statusMessage) {
    var status = PaymentStatus.emptyValue;
    switch (statusMessage) {
      case AppStrings.paymentStatusPendingValue:
        status = PaymentStatus.pending;
        break;

      case AppStrings.paymentStatusPaidValue:
        status = PaymentStatus.paid;
        break;

      case AppStrings.paymentStatusOverpaidValue:
        status = PaymentStatus.overPaid;
        break;

      case AppStrings.paymentStatusPartiallyPaidValue:
        status = PaymentStatus.partiallyPaid;
        break;

      case AppStrings.paymentStatusFailedValue:
        status = PaymentStatus.failed;
        break;

      case AppStrings.paymentStatusGatewayErrorValue:
        status = PaymentStatus.paymentGatewayError;
        break;

      case AppStrings.paymentStatusIOSPending:
        status = PaymentStatus.pending;
        break;

      case AppStrings.paymentStatusIOSPaid:
        status = PaymentStatus.paid;
        break;

      case AppStrings.paymentStatusIOSOverPaid:
        status = PaymentStatus.overPaid;
        break;

      case AppStrings.paymentStatusIOSPartiallyPaid:
        status = PaymentStatus.partiallyPaid;
        break;

      case AppStrings.paymentStatusIOSCancelled:
        status = PaymentStatus.cancelled;
        break;

      case AppStrings.paymentStatusIOSReversed:
        status = PaymentStatus.reversed;
        break;

      case AppStrings.paymentStatusIOSExpired:
        status = PaymentStatus.expired;
        break;

      case AppStrings.paymentStatusIOSFailed:
        status = PaymentStatus.failed;
        break;

      default:
        status = PaymentStatus.emptyValue;
    }

    return status;
  }
}

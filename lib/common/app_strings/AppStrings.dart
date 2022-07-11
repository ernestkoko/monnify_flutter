import 'package:flutter/foundation.dart';

/// App-wide class for holding strings for uniformity
abstract class AppStrings {
  ///Methods names to invoke

  static const initializeMonnify = "initialise_monnify";
  static const makeMonnifyPayment = "make_monnify_payment";

  ///Different app modes
  static const testMode = "test_mode";
  static const liveMode = "live_mode";
  static const cardPaymentKey = "card_payment";
  static const accountTransferKey = "account_transfer";

  ///Different keys for encoding message to be sent to server side
  static const apiKey = "api_key";
  static const contractCodeKey = "contract_code";
  static const appModeKey = "app_mode";
  static const amounToPayKey = "amount_to_pay";
  static const currencyCodeKey = "currency_code";
  static const customerNameKey = "customer_name";
  static const customerEmailKey = "customer_email";
  static const paymentReferenceKey = "payment_reference";
  static const paymentDescriptionKey = "payment_description";
  static const paymentMethodKey = "payment_method";

  ///Payment methods values
  static const paymentMethodCardValue = "card";
  static const paymentMethodBankTransferValue ="bank_transfer";
  static const  paymentMethodAllValue = "user_all";

  ///Different keys for decoding message gotten from server side
  ///
  ///
  /// keys for payment returned variables
  static const paidStatusMessageKey = "payment_status";
  static const paidCustomerNameKey = "paid_customer_name_key";
  static const paidCustomerEmailKey = "paid_customer_email_key";
  static const paidTransactionReferenceKey = "paid_transaction_response_key";
  static const paidCurrencyCodeKey = "paid_currency_code_key";
  static const paidPaymentDescriptionkey = "paid_description_key";
  static const paidPaymentReferenceKey = "paid_payment_reference_key";
  static const paidMessageKey = "paid_message_key";
  static const paidDateKey = "paid_date_key";
  static const paidAmountKey = "paid_amount_key";
  static const paidPaymentMethodKey = "paid_payment_method_key";
  static const paidAmountPayableKey = "paid_amount_payable_key";

  ///Pyament Status string keys
  static const paymentStatusPendingValue = "Transaction not paid.";
  static const paymentStatusPaidValue = "Customer paid exact amount.";
  static const paymentStatusOverpaidValue =
      "Customer paid more than expected amount.";
  static const paymentStatusPartiallyPaidValue =
      "Customer paid less than expected amount.";
  static const paymentStatusFailedValue =
      "Transaction completed unsuccessfully. This means no payment came in for Account Transfer method or attempt to charge card failed.";
  static const paymentStatusGatewayErrorValue = "Payment gateway error.";
  static const paymentStatusEmptyValue ="";
}

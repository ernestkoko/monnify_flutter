
///Enum that specify the application mode
enum ApplicationMode { test, live }

///Enum that specifies the Payment method
enum PaymentMethod { card, accountTransfer, all }


///Enum class that specifies the returned payment status when after transaction is made.
enum PaymentStatus {
  pending,
  paid,
  overPaid,
  partiallyPaid,
  failed,
  paymentgatewayError,
  emptyValue
}

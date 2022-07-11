import 'common/app_enums/EnumClasses.dart';
import 'common/model/transaction_model.dart';
import 'monnify_flutter_platform_interface.dart';

class MonnifyFlutter {
  ///Intsance of the Monnify Plugin
  static final MonnifyFlutter _instance = MonnifyFlutter();

  static MonnifyFlutter get instance => _instance;

  /// [initializeMonnify] calls the platforms APIs to initialise Monnify
  /// arguments [apiKey], [contractCode], [applicationMode] are required for this
  /// method to function.
  /// It returns a [String] or null
  Future<String?> initializeMonnify(
      {required String apiKey,
      required String contractCode,
      required ApplicationMode applicationMode}) async {
    try {
      final result = await MonnifyFlutterPlatform.instance.initializeMonnify(
          apiKey: apiKey, contractCode: contractCode, appMode: applicationMode);
      return result;
    } catch (error) {
      rethrow;
    }
  }

  ///[makePayment] sends request to the respective platforms to make payment
  ///Arguments String [amount], [currencyCode], [customerName], [customerEmail],
  ///[paymentReference], [paymentDescription], and [paymentMethod] are required
  ///for the method to work seamlessly
  Future<Transaction> makePayment(
      {required String amount,
      required String currencyCode,
      required String customerName,
      required String customerEmail,
      required String paymentReference,
      required String paymentDescription,
      required PaymentMethod paymentMethod}) async {
    try {
      final result = await MonnifyFlutterPlatform.instance.makePayment(
          amount: amount,
          currencyCode: currencyCode,
          customerName: customerName,
          customerEmail: customerEmail,
          paymentReference: paymentReference,
          paymentDescription: paymentDescription,
          paymentMethod: paymentMethod);
      final transaction = Transaction.fromMap(result);
      return transaction;
    } catch (error) {
      rethrow;
    }
  }
}

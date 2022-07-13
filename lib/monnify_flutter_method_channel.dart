import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'common/app_enums/EnumClasses.dart';
import 'common/app_strings/AppStrings.dart';
import 'common/model/payment_model.dart';
import 'monnify_flutter_platform_interface.dart';

/// An implementation of [MonnifyFlutterPlatform] that uses method channels.
class MethodChannelMonnifyFlutter extends MonnifyFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('monnify_flutter');

  @override
  Future<String?> initializeMonnify(
      {required String apiKey,
      required String contractCode,
      required ApplicationMode appMode}) async {
    //get the app mode
    final String mode = _getAppMode(appMode);

    //initialize the map to send to server
    final map = {
      AppStrings.apiKey: apiKey,
      AppStrings.contractCodeKey: contractCode,
      AppStrings.appModeKey: mode
    };

    try {

      final result =
          await methodChannel.invokeMethod(AppStrings.initializeMonnify, map);

      return result;

    } catch (error) {

      rethrow;

    }
  }

  @override
  Future<Map<String, dynamic>> makePayment(
      {required String amount,
      required String currencyCode,
      required String customerName,
      required String customerEmail,
        String? customerPhoneNumber,
      required String paymentReference,
      required String paymentDescription,
      required PaymentMethod paymentMethod}) async {

    final map = PaymentModel(
            amount: amount,
            currencyCode: currencyCode,
            customerName: customerName,
            paymentDescription: paymentDescription,
            paymentReference: paymentReference,
            customerEmail: customerEmail,
            customerPhoneNumber: customerPhoneNumber,
            paymentMethod: paymentMethod)
        .toMap();

    try {

      final result = await methodChannel.invokeMapMethod<String, String>(
          AppStrings.makeMonnifyPayment, map);

      return await Future.value(result);

    } catch (error) {

      rethrow;
    }
  }

  ///Return a string that corresponds to the mode the user passes in
  String _getAppMode(ApplicationMode mode) =>
      mode == ApplicationMode.test ? AppStrings.testMode : AppStrings.liveMode;
}

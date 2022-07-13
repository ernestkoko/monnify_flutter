import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'common/app_enums/EnumClasses.dart';
import 'monnify_flutter_method_channel.dart';

abstract class MonnifyFlutterPlatform extends PlatformInterface {
  /// Constructs a MonnifyFlutterPlatform.
  MonnifyFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MonnifyFlutterPlatform _instance = MethodChannelMonnifyFlutter();

  /// The default instance of [MonnifyFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelMonnifyFlutter].
  static MonnifyFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MonnifyFlutterPlatform] when
  /// they register themselves.
  static set instance(MonnifyFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> initializeMonnify(
      {required String apiKey,
      required String contractCode,
      required ApplicationMode appMode}) async {
    throw UnimplementedError('initializeMonnify() has not been implemented');
  }

  Future<Map<String, dynamic>> makePayment(
      {required String amount,
      required String currencyCode,
      required String customerName,
      required String customerEmail,
      required String paymentReference,
      required String paymentDescription,
      required PaymentMethod paymentMethod}) async {
    throw UnimplementedError("makePayment() not implemented");
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:monnify_flutter/common/app_enums/EnumClasses.dart';
import 'package:monnify_flutter/monnify_flutter.dart';
import 'package:monnify_flutter/monnify_flutter_platform_interface.dart';
import 'package:monnify_flutter/monnify_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMonnifyFlutterPlatform
    with MockPlatformInterfaceMixin
    implements MonnifyFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> initializeMonnify(
      {required String apiKey,
      required String contractCode,
      required ApplicationMode appMode}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> makePayment(
      {required String amount,
      required String currencyCode,
      required String customerName,
      required String customerEmail,
      required String paymentReference,
      required String paymentDescription,
      required PaymentMethod paymentMethod}) {
    throw UnimplementedError();
  }
}

void main() {
  final MonnifyFlutterPlatform initialPlatform =
      MonnifyFlutterPlatform.instance;

  test('$MethodChannelMonnifyFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMonnifyFlutter>());
  });

  test('initialise_monnify', () async {
    MonnifyFlutter monnifyFlutterPlugin = MonnifyFlutter();
    MockMonnifyFlutterPlatform fakePlatform = MockMonnifyFlutterPlatform();
    MonnifyFlutterPlatform.instance = fakePlatform;

    expect(
        await monnifyFlutterPlugin.initializeMonnify(
            apiKey: "apiKey",
            contractCode: "contractCode",
            applicationMode: ApplicationMode.test),
        "");
  });

  test('make_monnify_payment', () async {
    MonnifyFlutter monnifyFlutterPlugin = MonnifyFlutter();
    MockMonnifyFlutterPlatform fakePlatform = MockMonnifyFlutterPlatform();
    MonnifyFlutterPlatform.instance = fakePlatform;

    expect(
        await monnifyFlutterPlugin.makePayment(
            amount: "5000",
            currencyCode: "NGN",
            customerName: "Monni",
            customerEmail: "example@yahoo.com",
            paymentReference: "paymentReference",
            paymentDescription: "paymentDescription",
            paymentMethod: PaymentMethod.card),
        {});
  });
}

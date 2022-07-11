import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monnify_flutter/monnify_flutter_method_channel.dart';

void main() {
  MethodChannelMonnifyFlutter platform = MethodChannelMonnifyFlutter();
  const MethodChannel channel = MethodChannel('monnify_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

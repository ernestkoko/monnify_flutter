import 'package:flutter_test/flutter_test.dart';
import 'package:monnify_flutter/monnify_flutter.dart';
import 'package:monnify_flutter/monnify_flutter_platform_interface.dart';
import 'package:monnify_flutter/monnify_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMonnifyFlutterPlatform 
    with MockPlatformInterfaceMixin
    implements MonnifyFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MonnifyFlutterPlatform initialPlatform = MonnifyFlutterPlatform.instance;

  test('$MethodChannelMonnifyFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMonnifyFlutter>());
  });

  test('getPlatformVersion', () async {
    MonnifyFlutter monnifyFlutterPlugin = MonnifyFlutter();
    MockMonnifyFlutterPlatform fakePlatform = MockMonnifyFlutterPlatform();
    MonnifyFlutterPlatform.instance = fakePlatform;
  
    expect(await monnifyFlutterPlugin.getPlatformVersion(), '42');
  });
}

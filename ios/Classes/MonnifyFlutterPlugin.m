#import "MonnifyFlutterPlugin.h"
#if __has_include(<monnify_flutter/monnify_flutter-Swift.h>)
#import <monnify_flutter/monnify_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "monnify_flutter-Swift.h"
#endif

@implementation MonnifyFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMonnifyFlutterPlugin registerWithRegistrar:registrar];
}
@end

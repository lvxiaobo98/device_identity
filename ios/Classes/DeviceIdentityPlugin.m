#import "DeviceIdentityPlugin.h"
#if __has_include(<device_identity/device_identity-Swift.h>)
#import <device_identity/device_identity-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "device_identity-Swift.h"
#endif

@implementation DeviceIdentityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceIdentityPlugin registerWithRegistrar:registrar];
}
@end

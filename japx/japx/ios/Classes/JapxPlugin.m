#import "JapxPlugin.h"
#if __has_include(<japx/japx-Swift.h>)
#import <japx/japx-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "japx-Swift.h"
#endif

@implementation JapxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftJapxPlugin registerWithRegistrar:registrar];
}
@end

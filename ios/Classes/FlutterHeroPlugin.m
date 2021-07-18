#import "FlutterHeroPlugin.h"
#if __has_include(<flutter_hero_plugin/flutter_hero_plugin-Swift.h>)
#import <flutter_hero_plugin/flutter_hero_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_hero_plugin-Swift.h"
#endif

@implementation FlutterHeroPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterHeroPlugin registerWithRegistrar:registrar];
}
@end

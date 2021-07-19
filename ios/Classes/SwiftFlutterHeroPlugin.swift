import Flutter
import UIKit


struct Channel {
    static let flutter = "flutter_hero_plugin"
    static let event = "iblurblur/event"
    static let view = "iblurblur/method/view"
}

struct View {
    static let profile = "profile-view"
}

struct Method {
    static let getPlatformVersion = "getPlatformVersion"
    static let setName = "setName"
}

public class SwiftFlutterHeroPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Channel.flutter, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterHeroPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: Channel.event, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(ColorStreamHandler())
        
        let factory = ProfileViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: View.profile)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
}



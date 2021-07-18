import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHeroPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_hero_plugin');

  static const MethodChannel _methodViewChannel =
      const MethodChannel('iblurblur/method/view');

  static const EventChannel _eventChannel = const EventChannel('iblurblur/event');

  static const profileView = 'profile-view';

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> setName(String name) async {
    return await _methodViewChannel.invokeMethod('setName', name);
  }

  static Stream<dynamic>? get showColor {
    return _eventChannel.receiveBroadcastStream();
  }

}

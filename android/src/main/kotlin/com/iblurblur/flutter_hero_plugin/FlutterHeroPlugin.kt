package com.iblurblur.flutter_hero_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

const val METHOD_CHANNEL = "flutter_hero_plugin"
const val EVENT_CHANNEL = "iblurblur/event"
const val METHOD_VIEW_CHANNEL = "iblurblur/method/view"

const val PROFILE_VIEW = "profile-view"

const val GET_PLATFORM_VERSION_METHOD = "getPlatformVersion"
const val SET_NAME_METHOD = "setName"

class FlutterHeroPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
        channel.setMethodCallHandler(this)

        EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL).setStreamHandler(ColorStreamHandler())

        flutterPluginBinding
                .platformViewRegistry
                .registerViewFactory(PROFILE_VIEW, ProfileViewFactory(flutterPluginBinding.binaryMessenger))
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == GET_PLATFORM_VERSION_METHOD) {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

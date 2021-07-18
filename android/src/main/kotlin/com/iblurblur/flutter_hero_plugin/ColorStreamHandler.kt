package com.iblurblur.flutter_hero_plugin

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

class ColorStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private val color = listOf(0xff71C9CE, 0xffA6E3E9, 0xffCBF1F5, 0xffE3FDFD)
    private var index = 0

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        changeColor()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun changeColor() {
        val handler = Handler(Looper.getMainLooper())
        handler.post(object : Runnable {
            override fun run() {
                if (index >= color.count()) {
                    index = 0
                }
                eventSink?.success(color[index])
                index += 1
                handler.postDelayed(this, 3000)
            }
        })
    }
}

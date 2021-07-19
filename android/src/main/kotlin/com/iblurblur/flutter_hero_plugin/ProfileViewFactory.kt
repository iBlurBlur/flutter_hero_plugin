package com.iblurblur.flutter_hero_plugin

import android.app.Activity
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import com.bumptech.glide.Glide
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ProfileViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewIdentifier: Int, args: Any?): PlatformView {
        val arguments = args as Map<String?, Any?>
        return ProfileView(context, viewIdentifier, arguments, messenger)
    }
}

internal class ProfileView(context: Context, viewId: Int, args: Map<String?, Any?>?, messenger: BinaryMessenger) : PlatformView, MethodChannel.MethodCallHandler, ActivityAware {
    private lateinit var activity: Activity
    private val channel = MethodChannel(messenger, METHOD_VIEW_CHANNEL)
    private val parentLinearLayout: LinearLayout = LinearLayout(context)
    private lateinit var nameTextView: TextView
    private val defaultImage = "https://cdn-images-1.medium.com/max/280/1*X5PBTDQQ2Csztg3a6wofIQ@2x.png"

    init {
        channel.setMethodCallHandler(this)

        val name = args?.get("name") as? String
        val role = args?.get("role") as? String
        val image = args?.get("image") as? String
        createProfileView(context, name ?: "...", role ?: "...", image ?: defaultImage)
    }

    private fun createProfileView(context: Context, name: String, role: String, image: String) {
        val inflater: LayoutInflater = LayoutInflater.from(context)
        val inflatedLayout: View = inflater.inflate(R.layout.profile, parentLinearLayout, false)

        nameTextView = inflatedLayout.findViewById(R.id.profile_name)
        nameTextView.text = name

        inflatedLayout.findViewById<TextView>(R.id.profile_role).text = role

        Glide.with(context)
                .load(image)
                .circleCrop()
                .into(inflatedLayout.findViewById(R.id.profile_image))

        parentLinearLayout.addView(inflatedLayout)
    }

    override fun getView(): View = parentLinearLayout

    override fun dispose() {}

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != SET_NAME_METHOD) {
            result.notImplemented()
            return
        }
        val name = call.arguments.toString()
        if (name.isEmpty() || name.length < 5) {
            result.success(false)
            return
        }
        nameTextView.text = name
        result.success(true)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        //todo
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        //todo
    }

    override fun onDetachedFromActivity() {
        //todo
    }
}
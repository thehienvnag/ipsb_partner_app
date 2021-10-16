package com.ipsb.partner_app

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
//        FlutterMain.startInitialization(this);
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

    override fun registerWith(registry: PluginRegistry?) {
        val key: String? = FlutterFirebaseMessagingPlugin::class.java.canonicalName
        if (!registry?.hasPlugin(key)!!) {
            FlutterFirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin"));
        }

        if (registry != null) {
            FlutterLocalNotificationPluginRegistrant.registerWith(registry);
        }
    }

}
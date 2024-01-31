package com.example.lucky_money_assassin

import com.example.lucky_money_assassin.midware.AccessibilityChannelPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(AccessibilityChannelPlugin())
    }
}

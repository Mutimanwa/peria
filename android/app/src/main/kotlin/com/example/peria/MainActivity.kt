package com.example.peria

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "peria_app/security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecureFlag" -> {
                    try {
                        // Enable FLAG_SECURE to prevent screenshots and screen recording
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("SECURE_FLAG_ERROR", "Failed to enable secure flag", e.message)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

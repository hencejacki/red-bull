package com.example.lucky_money_assassin.midware;

import android.content.Context;
import android.content.Intent;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class AccessibilityChannelPlugin implements FlutterPlugin, MethodCallHandler {
    // 通道名称
    private final static String CHANNEL_NAME = "com.example.assassin/enableAccessibility";
    // 方法通道
    private MethodChannel _channel;
    // 当前应用上下文
    private Context _context;

    // 相关Service包名
    private final static String HONGBAO_SERVICE_PACKAGE_NAME = "com.example.lucky_money_assassin.service.HoneBaoService";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        _channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL_NAME);
        _channel.setMethodCallHandler(this);
        _context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "enableAccessibilityService":
                enableAccessibilityService();
                result.success(null);
                break;
            case "isAccessibilitySettingsOn": {
                boolean ret = isAccessibilitySettingsOn(HONGBAO_SERVICE_PACKAGE_NAME);
                result.success(ret);
                break;
            }
            case "disableAccessibility": {
                boolean ret = disableAccessibility();
                result.success(ret);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * 跳转无障碍服务界面
     */
    private void enableAccessibilityService() {
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        _context.startActivity(intent);
    }

    /**
     * 无障碍服务是否开启
     * @param accessibilityServiceName 无障碍服务名称
     * @return true: enabled; false: disabled
     */
    private boolean isAccessibilitySettingsOn(String accessibilityServiceName) {
        int accessEnabled = 0;
        String serviceName = _context.getPackageName() + "/" + accessibilityServiceName;
        Log.d("SettingsOn", serviceName);
        try {
            accessEnabled = Settings.Secure.getInt(_context.getContentResolver(), Settings.Secure.ACCESSIBILITY_ENABLED);
        } catch (Settings.SettingNotFoundException e) {
            Log.e("SettingsOn", "get accessibility enable failed, the err:" + e.getMessage());
        }
        if (1 == accessEnabled) {
            TextUtils.SimpleStringSplitter mStringColonSplitter = new TextUtils.SimpleStringSplitter(':');
            String settingValue = Settings.Secure.getString(_context.getContentResolver(), Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
            if (null != settingValue) {
                mStringColonSplitter.setString(settingValue);
                while (mStringColonSplitter.hasNext()) {
                    String accessibilityService = mStringColonSplitter.next();
                    if (accessibilityService.equalsIgnoreCase(serviceName)) {
                        Log.d("SettingsOn", "accessibility service:" + serviceName + " is on.");
                        return true;
                    }
                }
            }
        }else {
            Log.d("SettingsOn", "accessibility service disable.");
        }
        return false;
    }

    /**
     * 关闭无障碍服务
     * @return true: shutdown; false: still open
     */
    private boolean disableAccessibility() {
        // 1. 调用停止服务
        Intent intent = new Intent("com.example.lucky_money_assassin.ACTION_DISABLE_ACCESSIBILITY_SERVICE");
        _context.sendBroadcast(intent);
        // TODO: 检查是否关闭成功
        return true;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        _channel.setMethodCallHandler(null);
        _channel = null;
        _context = null;
    }
}

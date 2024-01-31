import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeController {
  bool isAnimated = false;
  bool isOpened = false;

  void showSnackBar(BuildContext context, bool status) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: status ? const Text("操作成功") : const Text("操作失败"),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ));
  }

  static const platform =
      MethodChannel('com.example.assassin/enableAccessibility');

  /// 开启无障碍服务
  Future<void> enableAccessibilityService() async {
    try {
      await platform.invokeMethod('enableAccessibilityService');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error invoking platform method: ${e.message}');
      }
    }
  }

  /// 检查无障碍服务是否开启
  Future<bool> isAccessibilitySettingsOn() async {
    try {
      bool ret = await platform.invokeMethod("isAccessibilitySettingsOn");
      return ret;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error invoking platform method: ${e.message}');
      }
      return false;
    }
  }

  /// 关闭无障碍服务
  Future<bool> disableAccessibility() async {
    try {
      bool ret = await platform.invokeMethod("disableAccessibility");
      return ret;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error invoking platform method: ${e.message}');
      }
      return false;
    }
  }
}

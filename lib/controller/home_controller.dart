import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeController {
  bool isAnimated = false;
  bool isOpened = false;

  void showSnackBar(BuildContext context, bool status,
      {String successContent = "操作成功",
      String failContent = "操作失败"}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: status ? Text(successContent) : Text(failContent),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ));
  }

  static const platform =
      MethodChannel('com.example.assassin/enableAccessibility');

  /// Jump to the accessibility service settings page, prompting the user to
  /// enable accessibility service. If the service is already enabled, this
  /// function does nothing.
  ///
  /// This function may throw a [PlatformException] if the platform channel
  /// invocation fails.
  Future<void> enableAccessibilityService() async {
    try {
      await platform.invokeMethod('enableAccessibilityService');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error invoking platform method: ${e.message}');
      }
    }
  }

  /// Checks if the accessibility settings are enabled.
  ///
  /// This function calls a platform-specific method to determine whether
  /// the accessibility service is currently enabled. It returns `true` if
  /// the service is enabled, and `false` otherwise. If the platform channel
  /// invocation fails, it logs an error message in debug mode and returns `false`.
  ///
  /// Returns a [Future] that resolves to a [bool] indicating the status of
  /// the accessibility settings.
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

  /// Disables the accessibility service.
  ///
  /// This function calls a platform-specific method to stop the accessibility
  /// service. It returns `true` if the service was successfully stopped, and
  /// `false` otherwise. If the platform channel invocation fails, it logs an
  /// error message in debug mode and returns `false`.
  ///
  /// Returns a [Future] that resolves to a [bool] indicating the status of the
  /// accessibility service.
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

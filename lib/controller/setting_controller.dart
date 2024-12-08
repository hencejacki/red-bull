import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController {
  // 监视选项
  bool monitorNotification = false;
  bool monitorChatList = false;

  // 防封号选项
  bool autoOpenRedPacket = true;
  int delayOpenRedPacket = 1;
  bool openSelfRedPacket = false;
  String shieldText = "";

  // 实验功能选项
  bool backendOpenRedPacket = false;

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Unimplemented!"),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ));
  }

  Future<void> launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

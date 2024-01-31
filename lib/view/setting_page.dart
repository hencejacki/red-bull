import 'package:flutter/material.dart';
import 'package:lucky_money_assassin/controller/setting_controller.dart';
import 'package:lucky_money_assassin/widgets/custom_text.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.controller});

  final SettingController controller;

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: CustomText(
            content: "监视选项",
          ),
        ),
        CheckboxListTile(
            title: const Text("监视系统通知"),
            subtitle: const Text("读取消息通知中的红包提示并进入聊天界面"),
            checkColor: Colors.white,
            value: widget.controller.monitorNotification,
            onChanged: (v) {
              setState(() {
                widget.controller.monitorNotification =
                    !widget.controller.monitorNotification;
              });
              widget.controller.showSnackBar(context);
            }),
        CheckboxListTile(
            title: const Text("监视聊天列表"),
            subtitle: const Text("读取聊天列表中的红包提示并进入聊天界面"),
            checkColor: Colors.white,
            value: widget.controller.monitorChatList,
            onChanged: (v) {
              setState(() {
                widget.controller.monitorChatList =
                    !widget.controller.monitorChatList;
              });
              widget.controller.showSnackBar(context);
            }),
        const Padding(
          padding: EdgeInsets.all(16),
          child: CustomText(
            content: "防封号选项",
          ),
        ),
        CheckboxListTile(
            title: const Text("自动拆红包"),
            checkColor: Colors.white,
            value: widget.controller.autoOpenRedPacket,
            onChanged: (v) {
              setState(() {
                widget.controller.autoOpenRedPacket =
                    !widget.controller.autoOpenRedPacket;
              });
              widget.controller.showSnackBar(context);
            }),
        ListTile(
          title: const Text("延时拆红包"),
          onTap: () {
            widget.controller.showSnackBar(context);
          },
        ),
        CheckboxListTile(
            title: const Text("拆自己发的红包"),
            checkColor: Colors.white,
            value: widget.controller.openSelfRedPacket,
            onChanged: (v) {
              setState(() {
                widget.controller.openSelfRedPacket =
                    !widget.controller.openSelfRedPacket;
              });
              widget.controller.showSnackBar(context);
            }),
        ListTile(
          title: const Text("屏蔽红包文字"),
          subtitle: const Text("不拆开包含某些文字的红包"),
          onTap: () {
            widget.controller.showSnackBar(context);
          },
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: CustomText(
            content: "关于应用",
          ),
        ),
        ListTile(
          title: const Text("检查新版本"),
          subtitle: const Text("https://github.com/hencejacki"),
          onTap: () {
            widget.controller.launchURL("https://github.com/hencejacki");
          },
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: CustomText(
            content: "实验功能",
          ),
        ),
        CheckboxListTile(
            title: const Text("息屏抢红包"),
            subtitle: const Text("保持后台活跃,谨慎使用"),
            checkColor: Colors.white,
            value: widget.controller.backendOpenRedPacket,
            onChanged: (v) {
              setState(() {
                widget.controller.backendOpenRedPacket =
                    !widget.controller.backendOpenRedPacket;
              });
              widget.controller.showSnackBar(context);
            }),
      ],
    );
  }
}

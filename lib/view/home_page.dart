import 'package:flutter/material.dart';
import 'package:red_bull/controller/home_controller.dart';
import 'package:red_bull/controller/setting_controller.dart';
import 'package:red_bull/view/setting_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title, required this.homeController});

  final HomeController homeController;

  final SettingController settingController = SettingController();

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double? _containerHeight;
  double? _borderRadius;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  /// 提醒对话框
  Future<void> _showAlertDialog(BuildContext context, VoidCallback? func,
      {String title = "提示", String content = "", String ok = ""}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: func,
              child: Text(ok),
            ),
          ],
        );
      },
    );
  }

  /// 动画播放
  void playAnimation(BuildContext context) {
    setState(() {
      widget.homeController.isAnimated = !widget.homeController.isAnimated;
    });
    startAnimation();
    widget.homeController.showSnackBar(context, true);
  }

  void openPacket(BuildContext ctx) async {
    bool isOpened = await widget.homeController.isAccessibilitySettingsOn();
    if (!isOpened) {
      if (!ctx.mounted) return;
      await _showAlertDialog(ctx, () async {
        await widget.homeController.enableAccessibilityService();
        ;
        if (!ctx.mounted) return;
        Navigator.pop(ctx, 'OK');
      }, title: "提示", content: "无障碍服务未开启", ok: "去开启");
    } else {
      if (!ctx.mounted) return;
      playAnimation(ctx);
    }
  }

  void closePacket(BuildContext ctx) async {
    bool isOpened = await widget.homeController.isAccessibilitySettingsOn();
    if (isOpened) {
      await widget.homeController.disableAccessibility();
      if (!ctx.mounted) return;
      playAnimation(ctx);
    } else {
      if (!ctx.mounted) return;
      await _showAlertDialog(ctx, () => {},
          title: "提示", content: "无障碍服务已关闭或未曾开启", ok: "关闭");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (!widget.homeController.isAnimated) {
      _borderRadius = screenWidth * 0.5;
      _containerHeight = screenHeight * 0.6;
    } else {
      _containerHeight = 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SettingPage(
            controller: widget.settingController,
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: screenWidth,
              height: _containerHeight,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Positioned(
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: screenWidth,
              height: _containerHeight,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(_borderRadius ?? 0))),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.2,
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width:
                      widget.homeController.isAnimated ? 0 : screenWidth * 0.5,
                  height:
                      widget.homeController.isAnimated ? 0 : screenHeight * 0.5,
                  decoration: const BoxDecoration(
                      color: Color(0xFFEBCD9A), shape: BoxShape.circle),
                )
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.2,
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: _animation.value,
                        child: TextButton(
                          onPressed: () => openPacket(context),
                          child: const Text(
                            "開",
                            style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3B3B3B)),
                          ),
                        ));
                  },
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: !widget.homeController.isAnimated
          ? null
          : FloatingActionButton(
              onPressed: () => playAnimation(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: IconButton(
                      onPressed: () => closePacket(context),
                      icon: const Icon(Icons.pause))),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

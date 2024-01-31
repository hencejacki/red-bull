import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucky_money_assassin/controller/home_controller.dart';
import 'package:lucky_money_assassin/controller/setting_controller.dart';
import 'package:lucky_money_assassin/view/setting_page.dart';

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
      // 如果动画已经完成，则反向执行动画
      _animationController.reverse();
    } else {
      // 如果动画未完成，则正向执行动画
      _animationController.forward();
    }
  }

  /// 提醒对话框
  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("检测到未开启无障碍服务, 是否开启?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                // 引导开启无障碍服务
                widget.homeController.enableAccessibilityService();
                Navigator.pop(context, 'OK');
              },
              child: const Text('去开启'),
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

  // 空白组件
  @Deprecated("")
  Widget emptyWidget() {
    return const SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取设备的宽度和高度
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (!widget.homeController.isAnimated) {
      // 根据屏幕宽度计算圆角大小
      _borderRadius = screenWidth * 0.5;
      // 计算容器高度
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
              duration: const Duration(seconds: 1), // 动画持续时间
              curve: Curves.easeInOut, // 动画曲线
              width: screenWidth,
              height: _containerHeight,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Positioned(
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1), // 动画持续时间
              curve: Curves.easeInOut, // 动画曲线
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
                  duration: const Duration(seconds: 1), // 动画持续时间
                  curve: Curves.easeInOut, // 动画曲线
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
                      child: const Text(
                        "開",
                        style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3B3B3B)),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.homeController.isAccessibilitySettingsOn().then(
          (isOpen) {
            // 已经开启
            if (isOpen) {
              if (widget.homeController.isOpened) {
                // 关闭服务
                widget.homeController.disableAccessibility().then((isShutdown) {
                  if (isShutdown) {
                    // 关闭成功
                    playAnimation(context);
                    widget.homeController.isOpened = false;
                  } else {
                    // 关闭失败
                    widget.homeController.showSnackBar(context, false);
                  }
                });
                return;
              }
              widget.homeController.isOpened = true;
              playAnimation(context);
            } else {
              // 未开启
              _showAlertDialog(context);
            }
          },
        ).catchError((err) {
          if (kDebugMode) {
            print(
                "Error when perform isAccessibilitySettingsOn action: ${err.toString()}");
          }
        }),
        tooltip: widget.homeController.isAnimated ? '红包?卸载!' : '红包?启动!',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: widget.homeController.isAnimated
            ? const Icon(Icons.pause)
            : const Icon(Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:chinese_font_library/chinese_font_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucky_money_assassin/common/device_util.dart';
import 'package:lucky_money_assassin/constant/theme_color.dart';
import 'package:lucky_money_assassin/controller/home_controller.dart';
import 'package:lucky_money_assassin/view/home_page.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await readDeviceInfo();
  if (!isDesktop) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: ThemeColor.systemSecondary));
  } else {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(450, 820),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
  }
  runApp(App());
}

class App extends StatelessWidget {
 App({super.key});

  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: ThemeColor.systemPrimary,
            onPrimary: ThemeColor.systemOnPrimary,
            secondary: ThemeColor.systemSecondary,
            onSecondary: ThemeColor.systemOnSecondary
          ),
          useMaterial3: true,
          textTheme: const TextTheme().useSystemChineseFont(Brightness.light)),
      home: HomePage(title: '红包刺客', homeController: controller,),
    );
  }
}

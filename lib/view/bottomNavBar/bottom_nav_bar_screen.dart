import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/view/home/home_screen.dart';
import 'package:future_green_world/view/home/select_topic.dart';
import 'package:future_green_world/view/newsFeed/news_feed_screen.dart';
import 'package:future_green_world/view/settings/settings_screen.dart';
import 'package:future_green_world/view/summary/summary_screen.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/controller/controller_instances.dart';
import '../shop/shop.dart';
import '../study_mode/study_mode.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  var _currentIndex = 0;
  var progressValue = 0.obs;
  late final WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(themeController.isDarkMode
          ? DarkModeColors.kBodyColor
          : AppColors.kWhite)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            progressValue.value = progress;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://futuregreenworld.info/')).then((value) {
        FlutterNativeSplash.remove();
      });
    super.initState();
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (_currentIndex == 2) {
      if (await controller.canGoBack()) {
        controller.goBack();
        return Future.value(false);
      } else {
        setState(() {
          _currentIndex = 0;
        });
        return Future.value(false);
      }
    } else {
      setState(() {
        _currentIndex = 0;
      });
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List pages = [
      HomeScreen(),
     // const SelectTopic(),
      // const HomeScreen(),
      //SummaryScreen(),
      ShopScreen(),
      StudyMode(),

      // Obx(() {
      //   return NewsFeedScreen(
      //     controller: controller,
      //     loading: progressValue.value < 100,
      //   );
      // }),
      const SettingScreen(),
    ];
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          backgroundColor: themeController.isDarkMode
              ? DarkModeColors.kBodyColor
              : AppColors.kWhite,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
                icon: Icon(Icons.home,
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.greyColor),
                title: const Text(""),
                selectedColor: AppColors.kPrimary,
                activeIcon: const Icon(
                  Icons.home,
                )),

            /// Summary
            SalomonBottomBarItem(
                icon: Icon(Icons.shopping_bag,
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.greyColor),
                title: const Text(""),
                selectedColor: AppColors.kPrimary,
                activeIcon: const Icon(Icons.shopping_bag)),

            /// News Feed
            SalomonBottomBarItem(
                icon: Icon(Icons.school,
                    color: themeController.isDarkMode
                        ? DarkModeColors.kWhite
                        : AppColors.greyColor),
                title: const Text(""),
                selectedColor: AppColors.kPrimary,
                activeIcon: const Icon(Icons.school)),

            /// Settings
            SalomonBottomBarItem(
                icon: Icon(
                  Icons.account_circle_sharp,
                  color: themeController.isDarkMode
                      ? DarkModeColors.kWhite
                      : AppColors.greyColor,
                ),
                title: const Text(""),
                selectedColor: AppColors.kPrimary,
                activeIcon: const Icon(
                  Icons.account_circle_sharp,
                )),
          ],
        ),
      ),
    );
  }
}

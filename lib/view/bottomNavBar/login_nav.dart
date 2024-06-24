import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/view/newsFeed/news_feed_screen.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/controller/controller_instances.dart';
import '../authentication/login_screen.dart';

class LoginNavScreen extends StatefulWidget {
  const LoginNavScreen({super.key});

  @override
  State<LoginNavScreen> createState() => _LoginNavScreenState();
}

class _LoginNavScreenState extends State<LoginNavScreen> {
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
    if (_currentIndex == 0) {
      if (await controller.canGoBack()) {
        controller.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
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
      Obx(() {
        return NewsFeedScreen(
          controller: controller,
          loading: progressValue.value < 100,
        );
      }),
      const LoginScreen(),
    ];
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        body: pages.last,
        // bottomNavigationBar: SalomonBottomBar(
        //   backgroundColor: themeController.isDarkMode
        //       ? DarkModeColors.kBodyColor
        //       : AppColors.kWhite,
        //   currentIndex: _currentIndex,
        //   onTap: (i) => setState(() => _currentIndex = i),
        //   items: [
        //     /// News Feed
        //     SalomonBottomBarItem(
        //         icon: Icon(
        //           Icons.feed_outlined,
        //           color: themeController.isDarkMode
        //               ? DarkModeColors.kWhite
        //               : AppColors.kBlack,
        //         ),
        //         title: const Text("NewsFeed"),
        //         selectedColor: AppColors.kPrimary,
        //         activeIcon: const Icon(Icons.feed)),
        //
        //     /// Login
        //     SalomonBottomBarItem(
        //         icon: Icon(
        //           Icons.lock_outline,
        //           color: themeController.isDarkMode
        //               ? DarkModeColors.kWhite
        //               : AppColors.kBlack,
        //         ),
        //         title: const Text("Login"),
        //         selectedColor: AppColors.kPrimary,
        //         activeIcon: const Icon(
        //           Icons.lock,
        //         )),
        //   ],
        // ),
      ),
    );
  }
}

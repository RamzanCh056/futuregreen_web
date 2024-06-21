import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/components/loading.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen(
      {super.key, required this.controller, required this.loading});

  final WebViewController controller;
  final bool loading;

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: (widget.loading)
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Center(child: Loading()), Text("Loading News...")],
                )
              : WebViewWidget(controller: widget.controller)),
    );
  }
}

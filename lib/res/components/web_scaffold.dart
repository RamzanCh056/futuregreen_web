import 'package:flutter/material.dart';
import 'package:future_green_world/res/colors/app_colors.dart';
import 'package:future_green_world/res/components/app_drawer.dart';

class WebScaffold extends StatefulWidget {
  final Widget body;

  const WebScaffold({required this.body, super.key});

  @override
  _WebScaffoldState createState() => _WebScaffoldState();
}

class _WebScaffoldState extends State<WebScaffold> {
  bool isAppDrawerClosed = false;

  void toggleDrawer() {
    setState(() {
      isAppDrawerClosed = !isAppDrawerClosed;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth * 0.15;
    double verticalPadding = screenheight * 0.04;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.greyColor),
          onPressed: toggleDrawer,
        ),
        title: Text(''),
      ),
      body: Row(
        children: [
          if (!isAppDrawerClosed) const AppDrawer(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: verticalPadding),
              child: widget.body,
            ),
          ),
        ],
      ),
    );
  }
}

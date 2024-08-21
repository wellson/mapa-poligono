import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/constants.dart';
import '../map/map_page.dart';
import 'app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({
    super.key,
  });

  static void run() => runApp(const AppWidget());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MapPage(),
    );
  }
}

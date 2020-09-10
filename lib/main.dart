import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:wow_addon_updater/models/get_addons.dart';
import 'package:wow_addon_updater/screens/home.dart';
//import 'package:wow_addon_updater/config.dart';

import 'screens/my_addons/my_addons_screen_old.dart';
import 'screens/get_addons/get_addons_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getWindowInfo().then((window) {
    if (window.screen != null) {
      print(window.screen.visibleFrame.width);
      print(window.screen.visibleFrame.height);
      final screenFrame = window.screen.visibleFrame;
      final width = math.max((screenFrame.width / 2).roundToDouble(), 1450.0);
      final height = math.max((screenFrame.height / 2).roundToDouble(), 800.0);
      final left = ((screenFrame.width - width) / 2).roundToDouble();
      final top = ((screenFrame.height - height) / 3).roundToDouble();
      final frame = Rect.fromLTWH(left, top, width, height);
      setWindowFrame(frame);
      setWindowMinSize(Size(0.5 * width, 0.5 * height));
      setWindowMaxSize(Size(1.5 * width, 1.5 * height));
      setWindowTitle('Flutter Testbed on ${Platform.operatingSystem}');
    }
  });

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white70,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      //home: GetAddonsScreen(),
      home: HomeScreen(),
    );
  }
}

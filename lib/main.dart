import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:wow_addon_updater/components/json.dart';
import './screens/home.dart';
import 'models/config.dart';

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
      setWindowTitle('WoW Addon Updater');
    }
  });

  var updaterFile = File('update.bat');
  var settingsFile = File('settings.json');

  if (updaterFile.existsSync()) {
    try {
      updaterFile.deleteSync();
    } catch (e) {
      print(e.toString());
    }
  }

  if (!settingsFile.existsSync()) {
    try {
      final config = Config(
        wowRetailFolder: r"C:\Program Files (x86)\World of Warcraft\_retail_\",
        wowBetaFolder: r"C:\Program Files (x86)\World of Warcraft\_beta_\",
        wowClassicFolder: r"C:\Program Files (x86)\World of Warcraft\_classic_\",
        wowRetailPTRFolder: r"C:\Program Files (x86)\World of Warcraft\_ptr_\",
      );
      print('Creating settings.json');
      String currentDirectory = Directory.current.path;
      createFile(config.toJson(), Directory(currentDirectory), 'settings.json', true);
    } catch (e) {
      print(e.toString());
    }
  }

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WoW Addon Updater',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white70,
        brightness: Brightness.dark,
        buttonColor: Colors.deepPurple,
        tabBarTheme: TabBarTheme(
          labelColor: Colors.deepPurpleAccent,
          unselectedLabelColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}

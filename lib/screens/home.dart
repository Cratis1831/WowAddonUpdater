import 'package:flutter/material.dart';

import './get_addons/get_addons_screen.dart';
import './my_addons/my_addons_screen.dart';
import './about/about_screen.dart';
import './settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        textTheme: Theme.of(context).textTheme,
        title: Text('WoW Addon Updater'),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
          labelColor: Theme.of(context).tabBarTheme.labelColor,
          tabs: [
            Tab(text: 'Get Addons', icon: Icon(Icons.get_app)),
            Tab(text: 'My Addons', icon: Icon(Icons.update)),
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
            Tab(text: 'About', icon: Icon(Icons.info)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GetAddonsScreen(),
          MyAddonsScreen(),
          SettingsScreen(),
          AboutScreen(),
        ],
      ),
    );
  }
}

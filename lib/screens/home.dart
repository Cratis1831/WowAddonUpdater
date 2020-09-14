import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wow_addon_updater/components/download_file.dart';
import 'package:wow_addon_updater/env.dart';
import 'package:path/path.dart' as path;

import '../models/github.dart';
import './get_addons/get_addons_screen.dart';
import './my_addons/my_addons_screen.dart';
import './about/about_screen.dart';
import './settings/settings_screen.dart';
import '../config.dart';

import 'package:process_run/shell.dart';

Future<List<GitHub>> github() async {
  final String _curseAddon = 'https://api.github.com/repos/asotoudeh18/WowAddonUpdater/releases';
  final response = await http
      .get(_curseAddon, headers: {HttpHeaders.authorizationHeader: 'TOKEN $gitHubApi', HttpHeaders.acceptHeader: 'application/vnd.github.v3+json'});
  List<GitHub> listOfAddons = List<GitHub>();
  print(_curseAddon);

  if (response.statusCode == 200) {
    print('Git Success Success');
    // If the server did return a 200 OK response,d
    // then parse the JSON.

    listOfAddons = (json.decode(response.body) as List).map((i) => GitHub.fromJson(i)).toList();

    return listOfAddons;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(json.decode(response.body));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<List<GitHub>> _github;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _github = github();
    Future.value(_github).then((githubReleases) {
      String currentGithubVersion;

      githubReleases.sort((b, a) => DateTime.parse(a.publishedAt).compareTo(DateTime.parse(b.publishedAt)));
      currentGithubVersion = githubReleases[0].tagName; //newest tag
      print('git: $currentGithubVersion - app: v$appVersion');
      if (currentGithubVersion != 'v$appVersion') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("WoW Addon Updater $currentGithubVersion is available!"),
              content: RichText(text: TextSpan(text: "Note: Update will taken moment to download and install")),
              actions: [
                FlatButton(
                  child: Text("Update & Restart", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Updating, Please wait..."),
                            content: SingleChildScrollView(child: LinearProgressIndicator()),
                          );
                        });
                    String fileUrl = githubReleases[0].assets[0].browserDownloadUrl;
                    String currentDirectory = Directory.current.path;
                    print(currentDirectory);
                    print(fileUrl);
                    var dio = Dio();
                    Future.delayed(Duration(seconds: 3)).then((value) {
                      downloadUpdate(
                        isUnzip: true,
                        isAppUpdate: true,
                        dio: dio,
                        url: fileUrl,
                        savePath: '$currentDirectory\\update\\',
                      );
                    });
                  },
                ),
                FlatButton(
                  child: Text("Close", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        textTheme: Theme.of(context).textTheme,
        title: Text('WoW Addon Updater v$appVersion'),
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

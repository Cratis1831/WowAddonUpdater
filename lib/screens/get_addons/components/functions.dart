import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wow_addon_updater/models/get_addons.dart';

Future<List<GetAddons>> fetchCurseData() async {
  final String _curseAddon = 'https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&pageSize=25&sort=0';
  final response = await http.get(_curseAddon);
  List<GetAddons> listOfAddons;
  print(_curseAddon);

  if (response.statusCode == 200) {
    print('Curse Success');
    // If the server did return a 200 OK response,d
    // then parse the JSON.

    listOfAddons = (json.decode(response.body) as List).map((i) => GetAddons.fromJson(i)).toList();

    return listOfAddons;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(json.decode(response.body));
  }
}

Future<void> launchInBrowser(String url) async {
  await Process.start(r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", [url]).then((process) {
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
  });
}

onSortColumn(int columnIndex, bool ascending, List<GetAddons> snapshot) {
  if (columnIndex >= 0) {
    if (ascending) {
      snapshot.sort((a, b) => a.name.compareTo(b.name));
    } else {
      snapshot.sort((a, b) => b.name.compareTo(a.name));
    }
  }
}

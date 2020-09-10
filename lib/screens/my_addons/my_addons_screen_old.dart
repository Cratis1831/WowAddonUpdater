import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart' as ps;
import '../../models/curse.dart';

Future<CurseAddon> fetchCurseData(String addonId) async {
  final String _curseAddon = 'https://addons-ecs.forgesvc.net/api/v2/addon/$addonId'; //2382 BigWig //61284 Details //23350 adibags
  final response = await http.get(_curseAddon);
  print(_curseAddon);

  if (response.statusCode == 200) {
    print('Curse Success');
    // If the server did return a 200 OK response,d
    // then parse the JSON.
    return CurseAddon.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(json.decode(response.body));
  }
}

Future getJson() async {
  List<CurseAddon> _curseData = [
    await fetchCurseData("2382"), // Big Wig
    await fetchCurseData("61284"), // Details
    await fetchCurseData("23350"), // AdiBags
    await fetchCurseData("360960")
  ];
  return [_curseData];
}

Future<void> _launchInBrowser(String url) async {
  await Process.start(r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", [url]).then((process) {
    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);
  });
}

class CurseScreen extends StatefulWidget {
  @override
  _CurseScreenState createState() => _CurseScreenState();
}

class _CurseScreenState extends State<CurseScreen> {
  Future<dynamic> futureCurseAddon;
  //Future<CurseAddon> futureCurseAddon;
  bool sort = true;
  int colIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //futureCurseAddon = fetchCurseData("2382");
    futureCurseAddon = getJson();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WoW Addon Updater',
      theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor,
        accentColor: Theme.of(context).accentColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('WoW Addon Updater'),
        ),
        body: Center(
          child: FutureBuilder(
            future: futureCurseAddon,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: buildSingleChildScrollView(snapshot.data[0]),
                      ),
                    )
                  ],
                );
                //print(snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(List<CurseAddon> snapshot) {
    //print(snapshot.map((e) => e.name));
    print(snapshot);
    onSortColumn(int columnIndex, bool ascending) {
      if (columnIndex >= 0) {
        if (ascending) {
          snapshot.sort((a, b) => a.name.compareTo(b.name));
        } else {
          snapshot.sort((a, b) => b.name.compareTo(a.name));
        }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortAscending: sort,
        sortColumnIndex: colIndex,
        showCheckboxColumn: false,
        dataRowHeight: 60,
        columnSpacing: MediaQuery.of(context).size.width * .05,
        columns: [
          DataColumn(
              label: const Text('Addon', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  sort = !sort;
                  colIndex = columnIndex;
                });
                onSortColumn(colIndex, sort);
              }),
          DataColumn(
              label: const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  sort = !sort;
                  colIndex = columnIndex;
                });
                onSortColumn(colIndex, sort);
              }),
          DataColumn(
              label: const Text('Latest Version', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  sort = !sort;
                  colIndex = columnIndex;
                });
                onSortColumn(colIndex, sort);
              }),
          DataColumn(
              label: const Text('Game Version', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  sort = !sort;
                  colIndex = columnIndex;
                });
                onSortColumn(colIndex, sort);
              }),
          DataColumn(
              label: const Text('Addon Source', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  sort = !sort;
                  colIndex = columnIndex;
                });
                onSortColumn(colIndex, sort);
              }),
          DataColumn(
              label: const Text('Addon Author', style: TextStyle(fontWeight: FontWeight.bold)),
              onSort: (columnIndex, sortAscending) {
                setState(() {
                  sort = !sort;
                  colIndex = columnIndex;
                });
                onSortColumn(colIndex, sort);
              }),
        ],
        rows: snapshot.map((addonData) {
          var _latestRetailRelease = addonData.latestFiles
              .indexWhere((element) => element.releaseType == ReleaseType.Release.index && !element.displayName.contains('-classic'));
          var _latestBetaRelease = addonData.latestFiles
              .indexWhere((element) => element.releaseType == ReleaseType.Beta.index && !element.displayName.contains('-classic'));
          var _latestAlphaRelease = addonData.latestFiles
              .indexWhere((element) => element.releaseType == ReleaseType.Alpha.index && !element.displayName.contains('-classic'));
          var _latestClassicRelease = addonData.latestFiles
              .indexWhere((element) => element.releaseType == ReleaseType.Release.index && element.displayName.contains('-classic'));
          var _latestRetailGameVersion =
              addonData.gameVersionLatestFiles.indexWhere((element) => element.gameVersionFlavor == "wow_retail" && element.fileType == 1);
          return DataRow(
            onSelectChanged: (b) {
              print(addonData.name);
            },
            cells: [
              DataCell(
                SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Image.network(
                          addonData.attachments[0].thumbnailUrl,
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addonData.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                addonData.latestFiles[_latestRetailRelease].fileName,
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  _launchInBrowser(addonData.websiteUrl);
                },
              ),
              DataCell(FlatButton(
                child: Text(
                  "Update",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                color: Colors.deepPurple,
                onPressed: () {},
              )),
              DataCell(Text(addonData.latestFiles[_latestRetailRelease].displayName, overflow: TextOverflow.ellipsis)),
              DataCell(Text(addonData.gameVersionLatestFiles[_latestRetailGameVersion].gameVersion, overflow: TextOverflow.ellipsis)),
              DataCell(Text("Curse")),
              DataCell(Text(addonData.authors[0].name, overflow: TextOverflow.ellipsis)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

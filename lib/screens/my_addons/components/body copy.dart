import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:wow_addon_updater/config.dart';
import 'package:wow_addon_updater/models/current_addons.dart';
import 'package:wow_addon_updater/models/get_addons.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<CurrentAddons>> futureCurrentAddons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCurrentAddons = fetchCurrentAddons();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: futureCurrentAddons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: buildSingleChildScrollView(snapshot.data),
                    //child: Text('Hello'),
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("ERROR:  ${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<GetAddons> fetchAddonInfo(String addonName) async {
    final String _curseAddon = 'https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&categoryId=0&searchFilter=$addonName';
    final response = await http.get(_curseAddon);
    List<GetAddons> listOfAddons;
    print(_curseAddon);

    if (response.statusCode == 200) {
      print('Curse Success');
      // If the server did return a 200 OK response,d
      // then parse the JSON.

      if ((json.decode(response.body) as List).map((i) => GetAddons.fromJson(i)).toList().isNotEmpty) {
        listOfAddons = (json.decode(response.body) as List).map((i) => GetAddons.fromJson(i)).toList();
        return listOfAddons[0];
      } else {
        return null;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(json.decode(response.body));
    }
  }

  Future<List<CurrentAddons>> fetchCurrentAddons() async {
    Directory retail = Directory(r"C:\Program Files (x86)\World of Warcraft\_retail_\Interface\Addons\");
    List<CurrentAddons> listOfAddons = List<CurrentAddons>();

    await retail.list().toList().then((value) async {
      for (var item in value) {
        if (item.toString().split(":")[0] == "Directory") {
          String addonFolderName = path.basename(item.path);
          // String addonTitleNameFromToc = "";
          String tempaddonTitleNameFromToc = "";
          String tempDependencies = "";
          bool findTitle = false;
          bool findDependencies = false;

          final file = new File('${item.path}\\$addonFolderName.toc');
          List<String> lines = file.readAsLinesSync();
          lines.forEach(
            (line) {
              if (line.contains("## Title: ")) {
                findTitle = true;
                tempaddonTitleNameFromToc = line.split("Title: ")[1];
                print('toc title: $tempaddonTitleNameFromToc');
              }
              if (line.contains("## Dependencies: ")) {
                findDependencies = true;
                tempDependencies = line.split("Dependencies: ")[1];
                print('toc dep: $tempDependencies');
              }
              if (findDependencies) {
                //addonTitleNameFromToc = tempDependencies;
                addonFolderName = tempDependencies;
              } else {
                addonFolderName = tempaddonTitleNameFromToc;
              }
            },
          );
          print('now: $addonFolderName');
          // await fetchAddonInfo(addonName.substring(0, 6)).then((value) {
          if (listOfAddons.indexWhere((element) => element.addonName == tempaddonTitleNameFromToc) == -1) {
            await fetchAddonInfo(addonFolderName).then((value) {
              if (value != null) {
                int latestFileIndex =
                    value.latestFiles.indexWhere((element) => element.releaseType == 1 && !element.displayName.contains('-classic'));
                print('latestFileIndex: $latestFileIndex');
                if (latestFileIndex != -1) {
                  int latestModuleIndex = value.latestFiles[latestFileIndex].modules.indexWhere((element) => element.foldername == addonFolderName);
                  print('latestModuleIndex: $latestModuleIndex');
                  if (latestModuleIndex != -1) {
                    String mainFolder = value.latestFiles[latestFileIndex].modules[latestModuleIndex].foldername;
                    print('mainFolder: $mainFolder');
                    if (mainFolder == addonFolderName && mainFolder != tempDependencies) {
                      CurrentAddons c = CurrentAddons(addonName: addonFolderName, btnText: "", isUpdate: true);
                      listOfAddons.add(c);
                    }
                  }
                }
              }
            });
          }
        }
      }
    });
    //print(listOfAddons);
    return listOfAddons;
  }

  SingleChildScrollView buildSingleChildScrollView(List<CurrentAddons> snapshot) {
    int count = 0;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortAscending: true,
        sortColumnIndex: 0,
        showCheckboxColumn: false,
        dataRowHeight: 60,
        columnSpacing: MediaQuery.of(context).size.width * .05,
        columns: [
          buildDataColumn(snapshot, "Addon"),
          buildDataColumn(snapshot, "Status"),
          buildDataColumn(snapshot, "Latest Version"),
          buildDataColumn(snapshot, "Game Version"),
          buildDataColumn(snapshot, "Source"),
          buildDataColumn(snapshot, "Author"),
        ],
        rows: snapshot.map(
          (currentAddons) {
            count += 1;
            print(currentAddons);
            return DataRow(
              cells: [
                DataCell(Text('$count - ${currentAddons.addonName}', overflow: TextOverflow.ellipsis)),
                DataCell(
                  currentAddons.isUpdate
                      ? FlatButton(
                          child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          color: Theme.of(context).buttonColor,
                          onPressed: () {
                            //downloadFile(currentAddons.latestFiles[_latestVersion].downloadUrl);

                            setState(() {
                              currentAddons.isUpdate = !currentAddons.isUpdate;
                              currentAddons.btnText = "Downloading...";
                            });
                            Timer(Duration(seconds: 1), () {
                              setState(() {
                                currentAddons.btnText = "Up to date";
                              });
                            });
                          },
                        )
                      : Text(currentAddons.btnText),
                ),
                DataCell(Text(currentAddons.addonName, overflow: TextOverflow.ellipsis)),
                DataCell(Text(currentAddons.addonName, overflow: TextOverflow.ellipsis)),
                DataCell(Text(currentAddons.addonName, overflow: TextOverflow.ellipsis)),
                DataCell(Text(currentAddons.addonName, overflow: TextOverflow.ellipsis)),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  DataColumn buildDataColumn(List<CurrentAddons> snapshot, String label) {
    return DataColumn(
        label: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        onSort: (columnIndex, sortAscending) {
          // setState(() {
          //   sort = !sort;
          //   colIndex = 0;
          // });
          // onSortColumn(colIndex, sort, snapshot);
        });
  }
}

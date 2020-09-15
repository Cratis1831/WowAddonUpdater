import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wow_addon_updater/components/download_file.dart';

import '../../../config.dart';
import '../../../models/current_addons.dart';
import '../../../models/get_addons.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool sort = true;
  int colIndex = 1;
  Future<List<CurrentAddons>> futureCurrentAddons;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCurrentAddons = fetchCurrentAddons();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: futureCurrentAddons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            return Column(
              //mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              //verticalDirection: VerticalDirection.down,

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
            print(snapshot.error);
            return Text("ERROR:  ${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<GetAddons>> fetchAddonInfo(String addonName) async {
    final String _curseAddon = 'https://addons-ecs.forgesvc.net/api/v2/addon/search?gameId=1&categoryId=0&searchFilter=${Uri.parse(addonName)}';
    final response = await http.get(_curseAddon);
    List<GetAddons> listOfAddons;
    //print(_curseAddon);

    if (response.statusCode == 200) {
      print('Curse Success');
      // If the server did return a 200 OK response,d
      // then parse the JSON.
      if ((json.decode(response.body) as List).map((i) => GetAddons.fromJson(i)).toList().isNotEmpty) {
        listOfAddons = (json.decode(response.body) as List).map((i) => GetAddons.fromJson(i)).toList();
        return listOfAddons;
      } else {
        return null;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(json.decode(response.body));
    }
  }

  onSortColumn(int columnIndex, bool ascending, List<CurrentAddons> snapshot) {
    if (columnIndex == 0) {
      if (ascending) {
        snapshot.sort((a, b) => a.addonName.compareTo(b.addonName));
      } else {
        snapshot.sort((a, b) => b.addonName.compareTo(a.addonName));
      }
    }
    if (columnIndex == 1) {
      if (ascending) {
        snapshot.sort((a, b) => a.isUpdated.toString().compareTo(b.isUpdated.toString()));
      } else {
        snapshot.sort((a, b) => b.isUpdated.toString().compareTo(a.isUpdated.toString()));
      }
    }
  }

  Future<List<CurrentAddons>> fetchCurrentAddons() async {
    Directory retail = Directory('$defaultWowDir\\Interface\\Addons\\');
    List<CurrentAddons> addonsMasterList = List<CurrentAddons>();
    List<CurrentAddons> onPCAddons = List<CurrentAddons>();
    List<String> addonSearchQuery = List<String>();

    await retail.list().toList().then((value) async {
      for (var item in value) {
        if (item.toString().split(":")[0] == "Directory") {
          String addonFolderName = path.basename(item.path);
          CurrentAddons currentAddonItem = CurrentAddons();

          final file = new File('${item.path}\\$addonFolderName.toc');
          List<String> lines = file.readAsLinesSync();

          currentAddonItem.onPCFolderName = path.basename(item.path);
          print(path.basename(item.path));
          lines.forEach(
            (line) {
              if (line.contains("## Interface: ") && currentAddonItem.currentAddonGameVersion == null) {
                currentAddonItem.currentAddonGameVersion = line.split("## Interface: ")[1];
              }
              if (line.contains("Version: ") && currentAddonItem.onPCVersion == null) {
                currentAddonItem.onPCVersion = line.split("Version: ")[1];
              }
              if (line.contains("## Title: ") && currentAddonItem.onPCTocTitle == null) {
                currentAddonItem.onPCTocTitle = line.split("Title: ")[1].replaceAll(new RegExp(r'[^\w\s]+'), '');
              }
              if (line.contains("## Dependencies: ") && currentAddonItem.onPCDependencies == null) {
                currentAddonItem.onPCDependencies = line.split("Dependencies: ")[1].replaceAll(new RegExp(r'[^\w\s]+'), '');
              }
            },
          );
          //print(currentAddonItem.toJson());
          //if (currentAddonItem.onPCDependencies == null) {
          // print(currentAddonItem.toJson());
          onPCAddons.add(currentAddonItem);
          addonSearchQuery.add(currentAddonItem.onPCFolderName);
          addonSearchQuery.add(currentAddonItem.onPCTocTitle);
          addonSearchQuery.add(currentAddonItem.onPCTocTitle.replaceAll(' ', ''));
          //}
        }
      }
    });

    await fetchAddonInfo(addonSearchQuery.join(",")).then((downloadedAddonList) {
      if (downloadedAddonList != null) {
        print(addonSearchQuery);
        for (var downloadedAddonItem in downloadedAddonList) {
          int latestFilesIndex =
              downloadedAddonItem.latestFiles.indexWhere((item) => (item.releaseType == 1) && item.gameVersionFlavor == 'wow_retail');
          print(latestFilesIndex);
          // LibGetFrame-1.0-1.5.1.zip
          int version = downloadedAddonItem.gameVersionLatestFiles.indexWhere((element) => element.fileType == 1);
          print(version);
          if (latestFilesIndex != -1) {
            //print('${downloadedAddonItem.latestFiles[latestFilesIndex].displayName} -  $latestFilesIndex');
            int modulesIndex = downloadedAddonItem.latestFiles[latestFilesIndex].modules.indexWhere((item) => item.type == 3);
            if (modulesIndex != -1) {
              //print('${downloadedAddonItem.latestFiles[latestFilesIndex].displayName} -  $modulesIndex');
              String downloadedFolderName = downloadedAddonItem.latestFiles[latestFilesIndex].modules[modulesIndex].foldername;
              int onPCAddonIndex = onPCAddons.indexWhere((item) => item.onPCFolderName == downloadedFolderName);
              if (onPCAddonIndex != -1) {
                // if (downloadedAddonItem.latestFiles[latestFilesIndex].gameVersion.isEmpty) {
                //   int backupFilesIndex =
                //       downloadedAddonItem.latestFiles.indexWhere((item) => (item.releaseType == 3) && item.gameVersionFlavor == 'wow_retail');
                //   if (backupFilesIndex != -1) {
                //     latestFilesIndex = backupFilesIndex;
                //   }
                // }

                //print('${downloadedAddonItem.latestFiles[latestFilesIndex].displayName} - $onPCAddonIndex');
                //print(onPCAddons[onPCAddonIndex].toJson());
                if (onPCAddons[onPCAddonIndex].dependencies == null)
                  onPCAddons[onPCAddonIndex].dependencies = downloadedAddonItem.latestFiles[latestFilesIndex].dependencies.isEmpty ? null : 'Yes';
                if (onPCAddons[onPCAddonIndex].addonName == null) onPCAddons[onPCAddonIndex].addonName = downloadedAddonItem.name;
                if (onPCAddons[onPCAddonIndex].latestVersion == null)
                  onPCAddons[onPCAddonIndex].latestVersion = downloadedAddonItem.latestFiles[latestFilesIndex].displayName;
                if (onPCAddons[onPCAddonIndex].gameVersion == null)
                  onPCAddons[onPCAddonIndex].gameVersion = downloadedAddonItem.gameVersionLatestFiles[version].gameVersion;
                if (onPCAddons[onPCAddonIndex].source == null) onPCAddons[onPCAddonIndex].source = "Curse";
                if (onPCAddons[onPCAddonIndex].authors == null) onPCAddons[onPCAddonIndex].authors = downloadedAddonItem.authors[0].name;
                if (onPCAddons[onPCAddonIndex].filename == null)
                  onPCAddons[onPCAddonIndex].filename = downloadedAddonItem.latestFiles[latestFilesIndex].fileName;
                if (onPCAddons[onPCAddonIndex].downloadUrl == null)
                  onPCAddons[onPCAddonIndex].downloadUrl = downloadedAddonItem.latestFiles[latestFilesIndex].downloadUrl;
                if (onPCAddons[onPCAddonIndex].slug == null) onPCAddons[onPCAddonIndex].slug = downloadedAddonItem.slug;

                String thumbnailUrl = 'https://vignette.wikia.nocookie.net/onceuponatime-fanon/images/1/14/No_Image_Available.jpg';
                if (downloadedAddonItem.attachments.isNotEmpty) {
                  int defaultThumbnailIndex = downloadedAddonItem.attachments.indexWhere((element) => element.isDefault);
                  if (defaultThumbnailIndex == -1) {
                    onPCAddons[onPCAddonIndex].thumbnailUrl = thumbnailUrl;
                  } else {
                    if (downloadedAddonItem.attachments[defaultThumbnailIndex].thumbnailUrl != null) {
                      onPCAddons[onPCAddonIndex].thumbnailUrl = downloadedAddonItem.attachments[defaultThumbnailIndex].thumbnailUrl;
                    } else {
                      onPCAddons[onPCAddonIndex].thumbnailUrl = thumbnailUrl;
                    }
                  }
                }
                if (onPCAddons[onPCAddonIndex].onPCVersion == null) onPCAddons[onPCAddonIndex].onPCVersion = 'Unable to locate';
                if (onPCAddons[onPCAddonIndex].onPCVersion.replaceAll('_', '.') != onPCAddons[onPCAddonIndex].latestVersion.replaceAll('_', '.') &&
                    !onPCAddons[onPCAddonIndex]
                        .onPCVersion
                        .replaceAll('_', '.')
                        .contains(onPCAddons[onPCAddonIndex].latestVersion.replaceAll('_', '.')) &&
                    !onPCAddons[onPCAddonIndex]
                        .latestVersion
                        .replaceAll('_', '.')
                        .contains(onPCAddons[onPCAddonIndex].onPCVersion.replaceAll('_', '.'))) {
                  //print('${downloadedAddonItem.name} - version');
                  onPCAddons[onPCAddonIndex].isUpdated = false;
                }
                if (!onPCAddons[onPCAddonIndex].slug.contains('beta')) {
                  print(onPCAddons[onPCAddonIndex].toJson());
                  if (onPCAddons[onPCAddonIndex].dependencies == null || onPCAddons[onPCAddonIndex].onPCDependencies == null) {
                    if ((addonsMasterList.indexWhere((element) => element.onPCFolderName == onPCAddons[onPCAddonIndex].onPCFolderName) == -1)) {
                      addonsMasterList.add(onPCAddons[onPCAddonIndex]);
                      //print(onPCAddons[onPCAddonIndex].toJson());
                    }
                  }
                }
              }
            }
          }
        }
      }
    });
    //print(listOfAddons.length);

    return addonsMasterList;
  }

  SingleChildScrollView buildSingleChildScrollView(List<CurrentAddons> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                child: Text("Update All", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                color: Theme.of(context).buttonColor,
                disabledColor: Colors.grey,
                onPressed: null,
                // onPressed: () {
                //   // for (var addon in snapshot) {
                //   //   setState(() {
                //   //     addon.isUpdated = !addon.isUpdated;
                //   //     addon.btnText = "Downloading...";
                //   //   });
                //   //   Future.delayed(Duration(seconds: 1)).then((value) {
                //   //     setState(() {
                //   //       //downloadFile(currentAddons.latestFiles[_latestVersion].downloadUrl);
                //   //       addon.btnText = "Up to date";
                //   //     });
                //   //   });
                //   // }
                // }
              ),
            ],
          ),
          DataTable(
            sortAscending: sort,
            sortColumnIndex: colIndex,
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
                //print(currentAddons);
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                          //width: MediaQuery.of(context).size.width * .4,
                          //decoration: BoxDecoration(border: Border.all()),
                          child: Row(
                        children: [
                          Image.network(
                            currentAddons.thumbnailUrl == null
                                ? 'https://vignette.wikia.nocookie.net/onceuponatime-fanon/images/1/14/No_Image_Available.jpg'
                                : currentAddons.thumbnailUrl,
                            height: 50,
                            width: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentAddons.addonName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Current Version: ${currentAddons.onPCVersion}',
                                  //style: TextStyle(color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      onTap: () {
                        //launchInBrowser(addonData.websiteUrl);
                      },
                    ),
                    DataCell(
                      currentAddons.isUpdated
                          ? SizedBox(
                              child: Text("Up to date"),
                              // width: MediaQuery.of(context).size.width * 0.1,
                            )
                          : currentAddons.onPCVersion != 'Unable to locate'
                              ? FlatButton(
                                  child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    setState(() {
                                      currentAddons.isUpdated = !currentAddons.isUpdated;
                                      currentAddons.btnText = "Downloading...";
                                    });
                                    print(currentAddons.downloadUrl);
                                    var dio = Dio();
                                    downloadUpdate(
                                      isUnzip: true,
                                      isAppUpdate: false,
                                      dio: dio,
                                      url: currentAddons.downloadUrl,
                                      savePath: '$defaultWowDir\\Interface\\Addons\\',
                                    ).then((value) {
                                      String newBtnText;
                                      if (value == 'OK') {
                                        newBtnText = 'Up to date';
                                      } else {
                                        newBtnText = value;
                                      }
                                      setState(() {
                                        //currentAddons.isUpdate = !currentAddons.isUpdate;
                                        currentAddons.btnText = newBtnText;
                                      });
                                    });
                                  },
                                )
                              : FlatButton(
                                  child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  color: Theme.of(context).buttonColor,
                                  disabledColor: Colors.grey,
                                  onPressed: null,
                                ),
                    ),
                    DataCell(Text(currentAddons.latestVersion, overflow: TextOverflow.ellipsis)),
                    DataCell(Text(currentAddons.gameVersion, overflow: TextOverflow.ellipsis)),
                    DataCell(Text(currentAddons.source, overflow: TextOverflow.ellipsis)),
                    DataCell(Text(currentAddons.authors, overflow: TextOverflow.ellipsis)),
                  ],
                );
              },
            ).toList(),
          ),
        ],
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
          setState(() {
            sort = !sort;
            colIndex = columnIndex;
          });
          onSortColumn(colIndex, sort, snapshot);
        });
  }
}

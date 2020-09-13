import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wow_addon_updater/config.dart';
import '../../components/download_file.dart';
import '../../models/get_addons.dart';
import './components/functions.dart';

class GetAddonsScreen extends StatefulWidget {
  @override
  _GetAddonsScreenState createState() => _GetAddonsScreenState();
}

class _GetAddonsScreenState extends State<GetAddonsScreen> {
  Future<List<GetAddons>> futureCurseAddon;
  bool sort = true;
  int colIndex = 0;
  String addonName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCurseAddon = fetchCurseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Addons'),
      ),
      body: Center(
        child: FutureBuilder(
          future: futureCurseAddon,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text("ERRORRRRR:  ${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView(List<GetAddons> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
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
        rows: snapshot.map((addonData) {
          var _latestRetailGameVersion =
              (addonData.gameVersionLatestFiles.indexWhere((element) => element.gameVersionFlavor == "wow_retail" && element.fileType == 1)) == -1
                  ? 0
                  : addonData.gameVersionLatestFiles.indexWhere((element) => element.gameVersionFlavor == "wow_retail" && element.fileType == 1);
          var _latestVersion = (addonData.latestFiles
                      .indexWhere((element) => element.fileName == addonData.gameVersionLatestFiles[_latestRetailGameVersion].projectFileName)) ==
                  -1
              ? 0
              : (addonData.latestFiles
                  .indexWhere((element) => element.fileName == addonData.gameVersionLatestFiles[_latestRetailGameVersion].projectFileName));
          return DataRow(
            key: Key(addonData.name),
            onSelectChanged: (b) {
              print(addonData.name);
            },
            cells: [
              DataCell(
                SizedBox(
                    child: Row(
                  children: [
                    Image.network(
                      addonData.attachments[0].thumbnailUrl,
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
                            addonData.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            addonData.gameVersionLatestFiles[_latestRetailGameVersion].projectFileName,
                            //style: TextStyle(color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                onTap: () {
                  launchInBrowser(addonData.websiteUrl);
                },
              ),
              DataCell(
                addonData.isUpdate
                    ? FlatButton(
                        child: Text("Download", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        color: Theme.of(context).buttonColor,
                        onPressed: () {
                          downloadFile(true, defaultWowDir, r'dump\', addonData.latestFiles[_latestVersion].downloadUrl);

                          setState(() {
                            addonData.isUpdate = !addonData.isUpdate;
                            addonData.btnText = "Downloading...";
                          });
                          Timer(Duration(seconds: 1), () {
                            setState(() {
                              addonData.btnText = "Up to date";
                            });
                          });
                        },
                      )
                    : Text(addonData.btnText),
              ),
              DataCell(Text(addonData.latestFiles[_latestVersion].displayName, overflow: TextOverflow.ellipsis)),
              DataCell(Text(addonData.gameVersionLatestFiles[_latestRetailGameVersion].gameVersion, overflow: TextOverflow.ellipsis)),
              DataCell(Text("Curse")),
              DataCell(Text(addonData.authors[0].name, overflow: TextOverflow.ellipsis)),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataColumn buildDataColumn(List<GetAddons> snapshot, String label) {
    return DataColumn(
        label: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        onSort: (columnIndex, sortAscending) {
          setState(() {
            sort = !sort;
            colIndex = 0;
          });
          onSortColumn(colIndex, sort, snapshot);
        });
  }
}

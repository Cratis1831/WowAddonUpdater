import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<String>> futureCurrentAddons;
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

  Future<List<String>> fetchCurrentAddons() async {
    Directory retail = Directory(r"C:\Program Files (x86)\World of Warcraft\_retail_\Interface\Addons\");
    List<String> listOfAddons = List<String>();
    await retail.list().toList().then((value) {
      for (var item in value) {
        listOfAddons.add(path.basename(item.path));
      }
    });
    //print(listOfAddons);
    return listOfAddons;
  }

  SingleChildScrollView buildSingleChildScrollView(List<String> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortAscending: true,
        sortColumnIndex: 0,
        showCheckboxColumn: false,
        dataRowHeight: 60,
        columnSpacing: MediaQuery.of(context).size.width * .05,
        columns: [
          DataColumn(
            label: Text(
              "Addon",
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        rows: snapshot.map(
          (currentAddons) {
            print(currentAddons);
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    currentAddons.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

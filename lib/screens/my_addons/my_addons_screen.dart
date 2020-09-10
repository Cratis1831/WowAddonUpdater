import 'package:flutter/material.dart';

import 'components/body.dart';

class MyAddonsScreen extends StatefulWidget {
  @override
  _MyAddonsScreenState createState() => _MyAddonsScreenState();
}

class _MyAddonsScreenState extends State<MyAddonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Addons"),
      ),
      body: Body(),
    );
  }
}

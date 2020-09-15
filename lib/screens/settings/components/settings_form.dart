import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wow_addon_updater/components/json.dart';
import 'package:wow_addon_updater/models/config.dart';
import 'dart:convert';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final wowRetailController = TextEditingController();
  final wowBetaController = TextEditingController();
  final wowClassicController = TextEditingController();
  final wowPtrController = TextEditingController();
  String wowRetailPath;

  @override
  void initState() {
    // TODO: implement initState
    String currentDirectory = Directory.current.path;
    Map<String, dynamic> x = jsonDecode(new File('$currentDirectory\\settings.json').readAsStringSync());
    Config cfg = Config.fromJson(x);
    wowRetailController.text = cfg.wowRetailFolder;
    wowBetaController.text = cfg.wowBetaFolder;
    wowClassicController.text = cfg.wowClassicFolder;
    wowPtrController.text = cfg.wowRetailPTRFolder;

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    wowRetailController.dispose();
    wowBetaController.dispose();
    wowClassicController.dispose();
    wowPtrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Config cfg2 = Config();
    String currentDirectory = Directory.current.path;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextFormField("WoW Retail Folder", "Enter the WoW Retail Folder here...", wowRetailController),
          buildTextFormField("WoW Beta Folder", "Enter the WoW Beta Folder here...", wowBetaController),
          buildTextFormField("WoW Retail PTR Folder", "Enter the WoW Retail PTR Folder here...", wowPtrController),
          buildTextFormField("WoW Classic Folder", "Enter the WoW Classic Folder here...", wowClassicController),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            onPressed: () {
              cfg2.wowRetailFolder = wowRetailController.text;
              cfg2.wowBetaFolder = wowBetaController.text;
              cfg2.wowRetailPTRFolder = wowPtrController.text;
              cfg2.wowClassicFolder = wowClassicController.text;
              createFile(cfg2.toJson(), Directory('$currentDirectory'), 'settings.json', true);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.indigo,
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField buildTextFormField(String _labelText, String _hintText, TextEditingController _controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _labelText,
        hintText: _hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Icon(Icons.edit),
      ),
      //initialValue: _initalValue,
      controller: _controller,
    );
  }
}

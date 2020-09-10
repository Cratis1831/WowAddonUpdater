import 'package:flutter/material.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  String wowRetailPath;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextFormField("WoW Retail Folder", "Enter the WoW Retail Folder here...", r"C:\Program Files (x86)\World of Warcraft\_retail_\"),
          buildTextFormField("WoW Beta Folder", "Enter the WoW Beta Folder here...", r"C:\Program Files (x86)\World of Warcraft\_beta_\"),
          buildTextFormField("WoW Retail PTR Folder", "Enter the WoW Retail PTR Folder here...", r"C:\Program Files (x86)\World of Warcraft\_ptr_\"),
          buildTextFormField("WoW Classic Folder", "Enter the WoW Classic Folder here...", r"C:\Program Files (x86)\World of Warcraft\_classic_\"),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            onPressed: () {},
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

  TextFormField buildTextFormField(String _labelText, String _hintText, String _initalValue) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: _labelText,
        hintText: _hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Icon(Icons.edit),
      ),
      initialValue: _initalValue,
    );
  }
}

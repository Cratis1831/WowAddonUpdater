import 'package:flutter/material.dart';
import 'package:wow_addon_updater/screens/settings/components/settings_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: EdgeInsets.all(50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SettingsForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

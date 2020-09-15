import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'models/config.dart';

const appVersion = '1.0.2';
const defaultButtonColour = Colors.deepPurple;
String currentDirectory = Directory.current.path;
Map<String, dynamic> x = jsonDecode(new File('$currentDirectory\\settings.json').readAsStringSync());
Config cfg = Config.fromJson(x);

String defaultWowDir = cfg.wowRetailFolder;

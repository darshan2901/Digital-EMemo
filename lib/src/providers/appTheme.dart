// ignore_for_file: file_names
 
import 'package:e_chalan/src/utility/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppTheme with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  AppTheme() {
    appLog("Apptheme initialized");
    getTheme();
  }

  getTheme() async {
    await Hive.openBox('Settings');
    var openbox = Hive.box("Settings");
    var mode = openbox.get('theme');
    if (mode == null) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = mode;
    }
    notifyListeners();
    openbox.close();
  }

  setTheme({required ThemeMode mode}) async {
    themeMode = mode;
    notifyListeners();

    await Hive.openBox('Settings');
    var openbox = Hive.box("Settings");
    openbox.put('theme', themeMode);
    openbox.close();
  }
}

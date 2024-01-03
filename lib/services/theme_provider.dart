import 'package:flutter/material.dart';

import 'local_storage.dart';

final localStorage = LocalStorageService();

class ThemeProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.system;

  ThemeProvider() {
    init();
  }

  init() async {
    var savedTheme = await localStorage.getData('theme');

    if (savedTheme != null) {
      theme = savedTheme['mode'] == 'light' ? ThemeMode.light : ThemeMode.dark;
      notifyListeners();
    }
  }

  changeTheme(ThemeMode themeMode) {
    theme = themeMode;

    notifyListeners();
  }
}

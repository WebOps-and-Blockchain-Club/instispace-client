import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/local_storage.dart';
import '../services/theme_provider.dart';

final localStorage = LocalStorageService();

class ThemeSwitch extends StatefulWidget {
  final bool isDark;
  final bool isHome;
  const ThemeSwitch({super.key, required this.isDark, required this.isHome});

  @override
  State<ThemeSwitch> createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  @override
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = widget.isDark;

    return GestureDetector(
      onTap: () async {
        setState(() {
          isDarkMode = !isDarkMode;
        });
        final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

        localStorage.setData('theme', {'mode': mode.name});
        Provider.of<ThemeProvider>(context, listen: false).changeTheme(mode);
      },
      child: widget.isHome
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isDarkMode
                      ? Icon(Icons.wb_sunny, color: Colors.yellow)
                      : Icon(
                          Icons.nightlight_round,
                          color: Colors.black,
                        ),
                ],
              ),
            )
          : Container(),
    );
  }
}

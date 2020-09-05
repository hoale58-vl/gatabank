import 'package:flutter/material.dart';
import 'package:gatabank/theme/theme_light.dart';

import 'themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode;

  Themes getTheme(BuildContext context) => lightTheme;

  setThemeMode(ThemeMode themeMode) {
    notifyListeners();
  }
}

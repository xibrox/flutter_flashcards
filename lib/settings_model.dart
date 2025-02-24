import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.indigo;
  String _language = 'en';

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  String get language => _language;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void updateAppBarColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void updateLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }
}

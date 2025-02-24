import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.indigo;
  String _language = 'en';

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  String get language => _language;

  SettingsModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _language = prefs.getString('language') ?? 'en';
    // Store color as an integer value.
    int? primaryColorValue = prefs.getInt('primaryColor');
    if (primaryColorValue != null) {
      _primaryColor = Color(primaryColorValue);
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
  }

  Future<void> updateAppBarColor(Color color) async {
    _primaryColor = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primaryColor', color.value);
  }

  Future<void> updateLanguage(String lang) async {
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }
}

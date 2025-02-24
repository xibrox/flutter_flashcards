import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Define some colors the user can choose from.
  final List<Color> availableColors = const [
    Colors.indigo,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(settings.language == 'en' ? 'Settings' : 'Настройки'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(
              settings.language == 'en' ? 'Dark Mode' : 'Темная тема',
            ),
            value: settings.isDarkMode,
            onChanged: (value) => settings.toggleDarkMode(value),
          ),
          const SizedBox(height: 16),
          Text(
            settings.language == 'en' ? 'App Color' : 'Цвет приложения',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                availableColors.map((color) {
                  return GestureDetector(
                    onTap: () => settings.updateAppBarColor(color),
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 20,
                      child:
                          settings.primaryColor == color
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            settings.language == 'en' ? 'Language' : 'Язык',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text('English'),
            trailing:
                settings.language == 'en' ? const Icon(Icons.check) : null,
            onTap: () => settings.updateLanguage('en'),
          ),
          ListTile(
            title: Text('Русский'),
            trailing:
                settings.language == 'ru' ? const Icon(Icons.check) : null,
            onTap: () => settings.updateLanguage('ru'),
          ),
        ],
      ),
    );
  }
}

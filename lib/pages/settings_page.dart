import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Available colors for selection.
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
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children:
                availableColors.map((color) {
                  return GestureDetector(
                    onTap: () => settings.updateAppBarColor(color),
                    child: CircleAvatar(
                      backgroundColor: color,
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
            leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
            title: const Text('English'),
            trailing:
                settings.language == 'en' ? const Icon(Icons.check) : null,
            onTap: () => settings.updateLanguage('en'),
          ),
          ListTile(
            leading: const Text('🇷🇺', style: TextStyle(fontSize: 24)),
            title: const Text('Русский'),
            trailing:
                settings.language == 'ru' ? const Icon(Icons.check) : null,
            onTap: () => settings.updateLanguage('ru'),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'pages/home_page.dart';
import 'settings_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CategorySchema],
    directory: dir.path,
    inspector: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: FlashcardsApp(isar: isar),
    ),
  );
}

class FlashcardsApp extends StatelessWidget {
  final Isar isar;
  const FlashcardsApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder: (context, settings, child) {
        return MaterialApp(
          title:
              settings.language == 'en'
                  ? 'Flashcards App'
                  : 'Приложение для карточек',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness:
                settings.isDarkMode ? Brightness.dark : Brightness.light,
            primaryColor: settings.primaryColor,
            scaffoldBackgroundColor:
                settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            appBarTheme: AppBarTheme(
              backgroundColor: settings.primaryColor,
              foregroundColor:
                  settings.isDarkMode ? Colors.white : Colors.grey[200],
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: settings.primaryColor,
              foregroundColor:
                  settings.isDarkMode ? Colors.white : Colors.grey[200],
            ),
          ),
          // Optionally, set the locale if you add more robust localization:
          locale: Locale(settings.language),
          home: HomePage(isar: isar),
        );
      },
    );
  }
}

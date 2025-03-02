import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  const FlashcardsApp({Key? key, required this.isar}) : super(key: key);

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
            textTheme: GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
            scaffoldBackgroundColor:
                settings.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            appBarTheme: AppBarTheme(
              backgroundColor: settings.primaryColor,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: settings.primaryColor,
              foregroundColor: Colors.white,
            ),
            cardColor: settings.isDarkMode ? Colors.grey[800] : Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          locale: Locale(settings.language),
          home: HomePage(isar: isar),
        );
      },
    );
  }
}

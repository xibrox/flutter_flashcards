import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [CategorySchema],
    directory: dir.path, // supply the directory here
    inspector: true,
  );
  runApp(FlashcardsApp(isar: isar));
}

class FlashcardsApp extends StatelessWidget {
  final Isar isar;
  const FlashcardsApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение для карточек',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.grey[200],
          elevation: 0,
        ),
      ),
      home: HomePage(isar: isar),
    );
  }
}

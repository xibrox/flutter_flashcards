import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import 'category_page.dart';
import 'settings_page.dart';
import '../settings_model.dart';

class HomePage extends StatefulWidget {
  final Isar isar;
  const HomePage({super.key, required this.isar});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await widget.isar.categories.where().findAll();
    setState(() {
      categories = cats;
    });
  }

  void _addCategory() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Provider.of<SettingsModel>(context, listen: false).language == 'en'
                ? 'Add Category'
                : 'Добавить категорию',
            style: TextStyle(
              color:
                  Provider.of<SettingsModel>(
                    context,
                    listen: false,
                  ).primaryColor,
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText:
                  Provider.of<SettingsModel>(context, listen: false).language ==
                          'en'
                      ? 'Category Name'
                      : 'Название категории',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final newCategory = Category()..name = controller.text;
                  await widget.isar.writeTxn(() async {
                    await widget.isar.categories.put(newCategory);
                  });
                  _loadCategories();
                }
                Navigator.pop(context);
              },
              child: Text(
                Provider.of<SettingsModel>(context, listen: false).language ==
                        'en'
                    ? 'Add'
                    : 'Добавить',
                style: TextStyle(
                  color:
                      Provider.of<SettingsModel>(
                        context,
                        listen: false,
                      ).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(Category category) async {
    await widget.isar.writeTxn(() async {
      await widget.isar.categories.delete(category.id);
    });
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          settings.language == 'en'
              ? 'Flashcards Categories'
              : 'Категории карточек',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body:
          categories.isEmpty
              ? Center(
                child: Text(
                  settings.language == 'en'
                      ? 'No categories added yet.'
                      : 'Категории пока не добавлены.',
                  style: const TextStyle(fontSize: 18),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    tileColor:
                        settings.isDarkMode ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteCategory(cat),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CategoryPage(
                                category: cat,
                                isar: widget.isar,
                              ),
                        ),
                      ).then((_) => _loadCategories());
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
}

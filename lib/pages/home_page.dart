import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import 'category_page.dart';
import 'settings_page.dart';
import '../settings_model.dart';

class HomePage extends StatefulWidget {
  final Isar isar;
  const HomePage({Key? key, required this.isar}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> categories = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final cats = await widget.isar.categories.where().findAll();
      setState(() {
        categories = cats;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading categories: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  try {
                    await widget.isar.writeTxn(() async {
                      await widget.isar.categories.put(newCategory);
                    });
                    _loadCategories();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding category: $e')),
                    );
                  }
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
    bool confirmed =
        await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  Provider.of<SettingsModel>(context, listen: false).language ==
                          'en'
                      ? 'Confirm Deletion'
                      : 'Подтвердите удаление',
                ),
                content: Text(
                  Provider.of<SettingsModel>(context, listen: false).language ==
                          'en'
                      ? 'Are you sure you want to delete this category?'
                      : 'Вы уверены, что хотите удалить эту категорию?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      Provider.of<SettingsModel>(
                                context,
                                listen: false,
                              ).language ==
                              'en'
                          ? 'Cancel'
                          : 'Отмена',
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      Provider.of<SettingsModel>(
                                context,
                                listen: false,
                              ).language ==
                              'en'
                          ? 'Delete'
                          : 'Удалить',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
    if (confirmed) {
      try {
        await widget.isar.writeTxn(() async {
          await widget.isar.categories.delete(category.id);
        });
        _loadCategories();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting category: $e')));
      }
    }
  }

  void _editCategory(Category category) {
    TextEditingController controller = TextEditingController(
      text: category.name,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Provider.of<SettingsModel>(context, listen: false).language == 'en'
                ? 'Edit Category'
                : 'Редактировать категорию',
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
                  category.name = controller.text;
                  try {
                    await widget.isar.writeTxn(() async {
                      await widget.isar.categories.put(category);
                    });
                    _loadCategories();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating category: $e')),
                    );
                  }
                }
                Navigator.pop(context);
              },
              child: Text(
                Provider.of<SettingsModel>(context, listen: false).language ==
                        'en'
                    ? 'Update'
                    : 'Обновить',
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

  Widget _buildEmptyState(SettingsModel settings) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 80,
            color: settings.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            settings.language == 'en'
                ? 'No categories yet!'
                : 'Пока нет категорий!',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addCategory,
            child: Text(
              settings.language == 'en'
                  ? 'Create First Category'
                  : 'Создать первую категорию',
            ),
          ),
        ],
      ),
    );
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : categories.isEmpty
              ? _buildEmptyState(settings)
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    tileColor: Provider.of<SettingsModel>(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => _editCategory(cat),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteCategory(cat),
                        ),
                      ],
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

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models.dart';
import 'category_page.dart';

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
    // Query all categories from the Isar database.
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
            'Добавить категорию',
            style: TextStyle(color: Colors.indigo),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Название категории',
              border: OutlineInputBorder(),
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
              child: Text('Добавить', style: TextStyle(color: Colors.indigo)),
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
    return Scaffold(
      appBar: AppBar(title: Text('Категории карточек'), centerTitle: true),
      body:
          categories.isEmpty
              ? Center(
                child: Text(
                  'Категории пока не добавлены.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
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
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.grey[200],
        child: Icon(Icons.add),
      ),
    );
  }
}

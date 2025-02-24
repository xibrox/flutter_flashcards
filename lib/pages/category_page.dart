import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import 'learn_page.dart';
import '../settings_model.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  final Isar isar;
  const CategoryPage({super.key, required this.category, required this.isar});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Category category;

  @override
  void initState() {
    super.initState();
    // Use the category passed from the HomePage.
    category = widget.category;
  }

  Future<void> _updateCategory() async {
    await widget.isar.writeTxn(() async {
      await widget.isar.categories.put(category);
    });
    setState(() {});
  }

  void _addFlashcard() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Provider.of<SettingsModel>(context, listen: false).language == 'en'
                ? 'Add a card'
                : 'Добавить карточку',
            style: TextStyle(
              color:
                  Provider.of<SettingsModel>(
                    context,
                    listen: false,
                  ).primaryColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<SettingsModel>(
                                  context,
                                  listen: false,
                                ).language ==
                                'en'
                            ? 'Question'
                            : 'Вопрос',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<SettingsModel>(
                                  context,
                                  listen: false,
                                ).language ==
                                'en'
                            ? 'Answer'
                            : 'Ответ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  final newFlashcard =
                      Flashcard()
                        ..question = questionController.text
                        ..answer = answerController.text;
                  // Create a modifiable copy of the flashcards list.
                  final updatedFlashcards = List<Flashcard>.from(
                    category.flashcards,
                  );
                  updatedFlashcards.add(newFlashcard);
                  category.flashcards = updatedFlashcards;
                  await _updateCategory();
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

  void _deleteFlashcard(int index) async {
    final updatedFlashcards = List<Flashcard>.from(category.flashcards);
    updatedFlashcards.removeAt(index);
    category.flashcards = updatedFlashcards;
    await _updateCategory();
  }

  void _startLearning() {
    if (category.flashcards.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnPage(flashcards: category.flashcards),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(icon: Icon(Icons.play_arrow), onPressed: _startLearning),
        ],
      ),
      body:
          category.flashcards.isEmpty
              ? Center(
                child: Text(
                  Provider.of<SettingsModel>(context, listen: false).language ==
                          'en'
                      ? 'No cards have been added yet.'
                      : 'Пока что карточки не добавлены.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: category.flashcards.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final flashcard = category.flashcards[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    tileColor:
                        settings.isDarkMode ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      flashcard.question,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteFlashcard(index),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlashcard,
        backgroundColor:
            Provider.of<SettingsModel>(context, listen: false).primaryColor,
        foregroundColor: Colors.grey[200],
        child: Icon(Icons.add),
      ),
    );
  }
}

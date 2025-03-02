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
    // Use the category passed from HomePage.
    category = widget.category;
  }

  Future<void> _updateCategory() async {
    try {
      await widget.isar.writeTxn(() async {
        await widget.isar.categories.put(category);
      });
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating category: $e')));
    }
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
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
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
                    border: const OutlineInputBorder(),
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

  Future<void> _deleteFlashcard(int index) async {
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
                      ? 'Are you sure you want to delete this card?'
                      : 'Вы уверены, что хотите удалить эту карточку?',
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
      final updatedFlashcards = List<Flashcard>.from(category.flashcards);
      updatedFlashcards.removeAt(index);
      category.flashcards = updatedFlashcards;
      await _updateCategory();
    }
  }

  void _editFlashcard(int index) {
    final flashcard = category.flashcards[index];
    TextEditingController questionController = TextEditingController(
      text: flashcard.question,
    );
    TextEditingController answerController = TextEditingController(
      text: flashcard.answer,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Provider.of<SettingsModel>(context, listen: false).language == 'en'
                ? 'Edit Card'
                : 'Редактировать карточку',
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
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
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
                    border: const OutlineInputBorder(),
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
                  flashcard.question = questionController.text;
                  flashcard.answer = answerController.text;
                  await _updateCategory();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _startLearning,
          ),
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
                  style: const TextStyle(fontSize: 18),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: category.flashcards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final flashcard = category.flashcards[index];
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
                      flashcard.question,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () => _editFlashcard(index),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _deleteFlashcard(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFlashcard,
        backgroundColor:
            Provider.of<SettingsModel>(context, listen: false).primaryColor,
        foregroundColor: Colors.grey[200],
        child: const Icon(Icons.add),
      ),
    );
  }
}

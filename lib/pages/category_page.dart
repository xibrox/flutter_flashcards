import 'package:flutter/material.dart';
import '../models.dart';
import 'learn_page.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  const CategoryPage({super.key, required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void _addFlashcard() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Flashcard', style: TextStyle(color: Colors.indigo)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    hintText: 'Question',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    hintText: 'Answer',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  setState(() {
                    widget.category.flashcards.add(
                      Flashcard(
                        question: questionController.text,
                        answer: answerController.text,
                      ),
                    );
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Add', style: TextStyle(color: Colors.indigo)),
            ),
          ],
        );
      },
    );
  }

  void _deleteFlashcard(int index) {
    setState(() {
      widget.category.flashcards.removeAt(index);
    });
  }

  void _startLearning() {
    if (widget.category.flashcards.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnPage(flashcards: widget.category.flashcards),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(icon: Icon(Icons.play_arrow), onPressed: _startLearning),
        ],
      ),
      body:
          widget.category.flashcards.isEmpty
              ? Center(
                child: Text(
                  'No flashcards added yet.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: widget.category.flashcards.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final flashcard = widget.category.flashcards[index];
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
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}

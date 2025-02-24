import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../models.dart';
import '../settings_model.dart';

class LearnPage extends StatefulWidget {
  final List<Flashcard> flashcards;
  const LearnPage({super.key, required this.flashcards});

  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.value < 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.flashcards.length;
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentFlashcard = widget.flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<SettingsModel>(context, listen: false).language == 'en'
              ? 'Learn'
              : 'Учеба',
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double angle = _controller.value * pi;
              Widget displayChild;
              if (angle <= pi / 2) {
                displayChild = _buildCardContent(currentFlashcard.question);
              } else {
                displayChild = Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child: _buildCardContent(currentFlashcard.answer),
                );
              }
              return Transform(
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                alignment: Alignment.center,
                child: displayChild,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCard,
        backgroundColor:
            Provider.of<SettingsModel>(context, listen: false).primaryColor,
        foregroundColor: Colors.grey[200],
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildCardContent(String text) {
    final settings = Provider.of<SettingsModel>(context);

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 300,
      decoration: BoxDecoration(
        color: settings.isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

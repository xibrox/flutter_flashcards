import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models.dart';
import '../settings_model.dart';

class LearnPage extends StatefulWidget {
  final List<Flashcard> flashcards;
  const LearnPage({Key? key, required this.flashcards}) : super(key: key);

  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _controller;
  late List<Flashcard> shuffledFlashcards;

  @override
  void initState() {
    super.initState();
    shuffledFlashcards = List.from(widget.flashcards);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void _shuffleCards() {
    setState(() {
      shuffledFlashcards.shuffle();
      currentIndex = 0;
      _controller.reset();
    });
  }

  void _flipCard() {
    HapticFeedback.mediumImpact();
    if (_controller.value < 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % shuffledFlashcards.length;
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentFlashcard = shuffledFlashcards[currentIndex];
    final settings = Provider.of<SettingsModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(settings.language == 'en' ? 'Learn' : 'Учеба'),
        actions: [
          IconButton(icon: const Icon(Icons.shuffle), onPressed: _shuffleCards),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _flipCard,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double angle = _controller.value * pi;
                    Widget displayChild;
                    if (angle <= pi / 2) {
                      displayChild = _buildCardContent(
                        currentFlashcard.question,
                      );
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Text(
              settings.language == 'en'
                  ? 'Card ${currentIndex + 1} of ${shuffledFlashcards.length}'
                  : 'Карточка ${currentIndex + 1} из ${shuffledFlashcards.length}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCard,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildCardContent(String text) {
    final settings = Provider.of<SettingsModel>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 300,
      decoration: BoxDecoration(
        color:
            settings.isDarkMode
                ? Colors.grey[800]
                : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}

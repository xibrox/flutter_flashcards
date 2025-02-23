import 'package:flutter/material.dart';
import 'dart:math';
import '../models.dart';

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
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.flashcards.length;
      // Reset card to the front (question side)
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentFlashcard = widget.flashcards[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Learn')),
      body: Center(
        child: GestureDetector(
          onTap: _flipCard,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              double angle = _animation.value * pi;
              // If more than half way, we show the back (answer)
              bool isUnder = _animation.value > 0.5;
              return Transform(
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      // The inner Transform rotates the text back if needed.
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(isUnder ? pi : 0),
                        child: Text(
                          isUnder
                              ? currentFlashcard.answer
                              : currentFlashcard.question,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextCard,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

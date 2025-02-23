class Category {
  String name;
  List<Flashcard> flashcards;

  Category({required this.name, required this.flashcards});
}

class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});
}

// A global list for categories (for simplicity).
List<Category> categories = [];

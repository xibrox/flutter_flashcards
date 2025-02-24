import 'package:isar/isar.dart';

part 'models.g.dart';

@Collection()
@Name("categories")
class Category {
  Id id = Isar.autoIncrement;
  late String name;
  List<Flashcard> flashcards = [];
}

@Embedded()
class Flashcard {
  late String question;
  late String answer;
}

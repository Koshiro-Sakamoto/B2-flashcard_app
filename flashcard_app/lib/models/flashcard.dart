import 'genre.dart';

class Flashcard {
  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.genre,
  });

  final int id;
  final String question;
  final String answer;
  final Genre genre;
}

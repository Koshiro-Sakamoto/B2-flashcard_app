import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/flashcard.dart';
import 'data/genre.dart';
import 'models/flashcard.dart';
import 'models/genre.dart';

// ジャンルは変化しないデータなので Provider で管理する
final genreProvider = Provider<List<Genre>>((ref) => genreList);

// カードは追加されて変化するデータなので NotifierProvider で管理する
final flashcardProvider =
    NotifierProvider<FlashcardListNotifier, List<Flashcard>>(
      FlashcardListNotifier.new,
    );

class FlashcardListNotifier extends Notifier<List<Flashcard>> {
  @override
  List<Flashcard> build() {
    return flashcardList;
  }

  void addCard(String question, String answer, Genre genre) {
    state = [
      ...state,
      Flashcard(
        id: state.length,
        question: question,
        answer: answer,
        genre: genre,
      ),
    ];
  }
}

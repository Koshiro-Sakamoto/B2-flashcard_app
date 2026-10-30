import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'data/flashcard.dart';
import 'data/genre.dart';
import 'flashcard_database.dart';
import 'models/flashcard.dart';
import 'models/genre.dart';

// ジャンルは変化しないデータなので Provider で管理する
final genreProvider = Provider<List<Genre>>((ref) => genreList);

final flashcardProvider = FutureProvider<List<Flashcard>>(
  (ref) => FlashcardDatabase().getFlashcards(),
);

final flashcardsByGenreProvider = FutureProvider.family<List<Flashcard>, int>(
  (ref, genreId) => FlashcardDatabase().getFlashcardsByGenre(genreId),
);

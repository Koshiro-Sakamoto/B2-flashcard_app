import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/flashcard.dart';
import 'data/genre.dart';
import 'flashcardcard_database.dart';
import 'models/flashcard.dart';
import 'models/genre.dart';

// ジャンルは変化しないデータなので Provider で管理する
final genreProvider = Provider<List<Genre>>((ref) => genreList);

// カードは追加されて変化するデータなので NotifierProvider で管理する

final flashcardProvider = FutureProvider<List<Flashcard>>(
  (ref) => FlashcardDatabase().getFlashcards(),
);

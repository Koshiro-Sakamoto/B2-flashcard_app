import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/genre.dart';
import '../models/flashcard.dart';
import '../models/genre.dart';

class FlashcardDatabase {
  factory FlashcardDatabase() => _instance;
  FlashcardDatabase._internal();
  static final FlashcardDatabase _instance = FlashcardDatabase._internal();
  late final Database database; // late:絶対に後で代入するという安全装置

  Future<Database> initDatabase() async {
    const scripts = {
      1: [
        'CREATE TABLE Flashcard(id INTEGER PRIMARY KEY AUTOINCREMENT, question TEXT, answer TEXT, genreId INTEGER);',
      ],
    };
    database = await openDatabase(
      join(await getDatabasesPath(), 'flashcard.db'),
      version: 1,
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var i = oldVersion + 1; i <= newVersion; i++) {
          final queries = scripts[i] ?? [];
          for (final query in queries) {
            await db.execute(query);
          }
        }
      },
    );
    return database;
  }

  Future<List<Flashcard>> getFlashcards() async {
    final List<Map<String, dynamic>> rows = await database.query('Flashcard');
    return rows.map((row) {
      final genre = genreList.firstWhere((genre) => genre.id == row['genreId']);
      return Flashcard(
        id: row['id'],
        question: row['question'],
        answer: row['answer'],
        genre: genre,
      );
    }).toList();
  }

  Future<void> insertFlashcard(
    String question,
    String answer,
    Genre genre,
  ) async {
    await database.insert(
      'Flashcard',
      {'question': question, 'answer': answer, 'genreId': genre.id},
      conflictAlgorithm: ConflictAlgorithm.ignore, // conflict が起きた場合、古い情報を優先
    );
  }

  Future<void> seedInitialFlashcardsIfEmpty(
    List<Flashcard> initialFlashcards,
  ) async {
    final flashcards = await getFlashcards();
    if (flashcards.isNotEmpty) return;
    for (final flashcard in initialFlashcards) {
      await insertFlashcard(
        flashcard.question,
        flashcard.answer,
        flashcard.genre,
      );
    }
  }
}

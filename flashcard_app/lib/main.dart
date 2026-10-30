import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/flashcard.dart';
import 'flashcard_database.dart';
import 'models/genre.dart';
import 'pages/card_add.dart';
import 'pages/card_list.dart';
import 'pages/genre_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlashcardDatabase().initDatabase();
  await FlashcardDatabase().seedInitialFlashcardsIfEmpty(flashcardList);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flashcard',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/',
      routes: {
        '/': (context) => const GenreListPage(),
        '/card_list': (context) => CardListPage(
          genre: ModalRoute.of(context)!.settings.arguments as Genre,
        ),
        '/card_add': (context) => CardAddPage(
          genre: ModalRoute.of(context)!.settings.arguments as Genre,
        ),
      },
    );
  }
}

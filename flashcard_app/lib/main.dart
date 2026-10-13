import 'package:flutter/material.dart';

import 'models/genre.dart';
import 'pages/card_add.dart';
import 'pages/card_list.dart';
import 'pages/genre_list.dart';

void main() {
  runApp(const MyApp());
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

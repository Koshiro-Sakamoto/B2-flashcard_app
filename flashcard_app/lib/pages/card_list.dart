import 'package:flutter/material.dart';

import '../data/flashcard.dart';
import '../models/flashcard.dart';
import '../models/genre.dart';

class CardListPage extends StatefulWidget {
  const CardListPage({super.key, required this.genre});

  final Genre genre;

  @override
  State<CardListPage> createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  void activateModal(BuildContext context, Flashcard content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            content.question,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(content.answer),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shownList = flashcardList
        .where((card) => card.genre.id == widget.genre.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.genre.title)),

      body: ListView.builder(
        itemCount: shownList.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(shownList[index].question),
            onTap: () {
              activateModal(context, shownList[index]);
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/card_add', arguments: widget.genre);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/flashcard.dart';
import '../models/genre.dart';
import '../providers.dart';

class CardListPage extends ConsumerWidget {
  const CardListPage({super.key, required this.genre});

  final Genre genre;

  void activateModal(BuildContext context, Flashcard content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            content.question,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final shownListAsync = ref.watch(flashcardsByGenreProvider(genre.id));
    return Scaffold(
      appBar: AppBar(title: Text(genre.title)),
      body: shownListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
        data: (shownList) {
          return ListView.builder(
            itemCount: shownList.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(shownList[index].question),
                onTap: () {
                  activateModal(context, shownList[index]);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/card_add', arguments: genre);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

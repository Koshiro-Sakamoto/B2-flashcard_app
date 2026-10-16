import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class GenreListPage extends ConsumerWidget {
  const GenreListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genreList = ref.watch(genreProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('ジャンル選択')),
      body: ListView.builder(
        itemCount: genreList.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(genreList[index].title),
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/card_list', arguments: genreList[index]);
            },
          ),
        ),
      ),
    );
  }
}

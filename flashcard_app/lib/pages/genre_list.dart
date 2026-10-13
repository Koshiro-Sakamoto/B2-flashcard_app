import 'package:flutter/material.dart';

import '../data/genre.dart';

class GenreListPage extends StatelessWidget {
  const GenreListPage({super.key});

  @override
  Widget build(BuildContext context) {
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

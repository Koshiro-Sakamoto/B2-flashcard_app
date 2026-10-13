import 'package:flutter/material.dart';

import '../data/flashcard.dart';
import '../data/genre.dart';
import '../models/flashcard.dart';
import '../models/genre.dart';

class CardAddPage extends StatefulWidget {
  const CardAddPage({super.key, required this.genre});

  final Genre genre;

  @override
  State<CardAddPage> createState() => _CardAddPageState();
}

class _CardAddPageState extends State<CardAddPage> {
  final formKey = GlobalKey<FormState>();
  final questionFormKey = GlobalKey<FormFieldState<String>>();
  final answerFormKey = GlobalKey<FormFieldState<String>>();
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.genre.id;
  }

  void addCard(String question, String answer, Genre genre) {
    flashcardList.add(
      Flashcard(
        id: flashcardList.length,
        question: question,
        answer: answer,
        genre: genre,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownMenuItemList = <DropdownMenuItem<int>>[];

    for (var i = 0; i < genreList.length; i++) {
      dropdownMenuItemList.add(
        DropdownMenuItem(
          value: genreList[i].id,
          child: Text(genreList[i].title),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('カード追加')),

      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            spacing: 16,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: DropdownButton(
                  value: selectedValue,
                  items: dropdownMenuItemList,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  isExpanded: true,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  key: questionFormKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '問題',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim() == '') {
                      return '入力してください';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  key: answerFormKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '答え',
                    alignLabelWithHint: true,
                  ),
                  minLines: 4,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim() == '') {
                      return '入力してください';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final question = questionFormKey.currentState!.value!;
                      final answer = answerFormKey.currentState!.value!;
                      final genre = genreList[selectedValue];
                      addCard(question, answer, genre);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('カードを追加する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

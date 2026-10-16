import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/genre.dart';
import '../providers.dart';

class CardAddPage extends ConsumerStatefulWidget {
  const CardAddPage({super.key, required this.genre});

  final Genre genre;

  @override
  ConsumerState<CardAddPage> createState() => _CardAddState();
}

// ConsumerState に修正
class _CardAddState extends ConsumerState<CardAddPage> {
  final formKey = GlobalKey<FormState>();
  final questionFormKey = GlobalKey<FormFieldState<String>>();
  final answerFormKey = GlobalKey<FormFieldState<String>>();
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.genre.id;
  }

  @override
  Widget build(BuildContext context) {
    // WidgetRef は書かないでよい

    final genreList = ref.watch(genreProvider);
    final dropdownMenuItemList = genreList.map((genre) {
      return DropdownMenuItem(value: genre.id, child: Text(genre.title));
    }).toList();

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
                      final genre = genreList.firstWhere(
                        (genre) => genre.id == selectedValue,
                      );
                      // NotifierProvider 経由でカードを追加する
                      ref
                          .read(flashcardProvider.notifier)
                          .addCard(question, answer, genre);
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

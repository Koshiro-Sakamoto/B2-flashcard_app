import '../models/flashcard.dart';
import 'genre.dart';

final List<Flashcard> flashcardList = [
  // --- 英単語 (genreList[0]) ---
  Flashcard(id: 0, question: 'apple', answer: 'りんご', genre: genreList[0]),
  Flashcard(
    id: 1,
    question: 'make',
    answer: '''作る
過去形 made
過去分詞 made''',
    genre: genreList[0],
  ),
  Flashcard(id: 2, question: 'cat', answer: '猫', genre: genreList[0]),

  // --- 世界史 (genreList[1]) ---
  Flashcard(
    id: 3,
    question: 'フランス革命',
    answer: '''1789年にフランスで起きた市民革命。
絶対王政が倒され、人権宣言が採択された。''',
    genre: genreList[1],
  ),
  Flashcard(
    id: 4,
    question: '産業革命',
    answer: '''18世紀後半にイギリスで始まった技術革新。
蒸気機関の発明などにより、工場制機械工業が発展した。''',
    genre: genreList[1],
  ),
  Flashcard(
    id: 5,
    question: 'ルネサンス',
    answer: '''14世紀〜16世紀に西欧で起きた文化運動。
古代ギリシア・ローマの文化を復興しようとした。「再生」を意味する。''',
    genre: genreList[1],
  ),

  // --- 情報 (genreList[2]) ---
  Flashcard(
    id: 6,
    question: 'CPU',
    answer: '''Central Processing Unit (中央処理装置)。
コンピュータの「頭脳」にあたり、プログラムの命令を解釈・実行する。''',
    genre: genreList[2],
  ),
  Flashcard(
    id: 7,
    question: 'RAM',
    answer: '''Random Access Memory。
コンピュータの主記憶装置（メモリ）。作業用の「机の広さ」に例えられ、電源を切るとデータが消える揮発性を持つ。''',
    genre: genreList[2],
  ),
  Flashcard(
    id: 8,
    question: 'HTTP',
    answer: '''HyperText Transfer Protocol。
WebブラウザとWebサーバ間で、HTMLなどのデータを送受信するための通信プロトコル（規約）。''',
    genre: genreList[2],
  ),
];

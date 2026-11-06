# Riverpod（Provider）導入でつまずきやすいポイント

`feat/provider` ブランチでは、暗記カードアプリの状態管理を **グローバル変数の直接操作** から **Riverpod（flutter_riverpod ^3.x）** に置き換えました。
このドキュメントでは、変更内容に沿って「初学者がつまずきやすいところ」「覚えておくべきこと」をまとめます。

---

## 0. 全体像：何がどう変わったか

| 項目 | 変更前 | 変更後 |
| --- | --- | --- |
| データの持ち方 | `data/` のグローバル変数を各画面が直接 import | `providers.dart` の Provider 経由で取得 |
| ジャンル一覧 | `genreList` を直接参照 | `genreProvider`（`Provider`） |
| カード一覧 | `flashcardList` を直接参照・`add` | `flashcardProvider`（`NotifierProvider`） |
| 画面の種類 | `StatelessWidget` / `StatefulWidget` | `ConsumerWidget` / `ConsumerStatefulWidget` |
| アプリの起点 | `runApp(const MyApp())` | `runApp(const ProviderScope(child: MyApp()))` |

**ポイント：画面（pages）は `data/` を import しなくなり、`providers.dart` だけを見るようになった。**
データの場所・更新方法が 1 か所に集まるのが Provider を使う最大のメリットです。

---

## 1. パッケージの追加と `ProviderScope`

```yaml
# pubspec.yaml
dependencies:
  flutter_riverpod: ^3.4.3
```

```dart
// main.dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

### つまずきポイント
- **`ProviderScope` で包み忘れると実行時エラー**になります（`No ProviderScope found`）。
  Provider の値は `ProviderScope` の中に保存されるので、アプリ全体をこれで包むのが必須です。
- パッケージ名は `provider` ではなく **`flutter_riverpod`**。import も
  `package:flutter_riverpod/flutter_riverpod.dart` です。名前が似ている別パッケージ（`provider`, `riverpod`, `hooks_riverpod`）と混同しないように。
- `pubspec.yaml` を書き換えたら `flutter pub get` を忘れずに。

---

## 2. Provider の種類を「データが変わるかどうか」で選ぶ

```dart
// providers.dart

// ジャンルは変化しないデータ → Provider
final genreProvider = Provider<List<Genre>>((ref) => genreList);

// カードは追加されて変化するデータ → NotifierProvider
final flashcardProvider =
    NotifierProvider<FlashcardListNotifier, List<Flashcard>>(
      FlashcardListNotifier.new,
    );
```

| 種類 | 用途 | このアプリでの例 |
| --- | --- | --- |
| `Provider` | 読み取り専用の値（変わらない） | ジャンル一覧 |
| `NotifierProvider` | 画面から変更したい状態 | カード一覧（追加される） |

### つまずきポイント
- **`Provider` の値は外から書き換えられません。** 「あとで追加・削除したい」データなら最初から `NotifierProvider` を選ぶ。
- Provider は **トップレベル（クラスの外）に `final` で宣言**します。グローバル変数に見えますが、実際の値は `ProviderScope` が管理しているので問題ありません。
- 型引数 `NotifierProvider<Notifierクラス, 状態の型>` の **順番** に注意（Notifier が先、状態が後）。
- `FlashcardListNotifier.new` は「コンストラクタそのもの」を渡す書き方です。`() => FlashcardListNotifier()` と同じ意味。
- Riverpod 3 では古い `StateProvider` / `StateNotifierProvider` / `ChangeNotifierProvider` は legacy 扱いです。ネット上の古い記事のコードがそのまま動かないことがあるので、**バージョンを確認**しましょう。

---

## 3. Notifier の書き方と「state は作り直す」ルール

```dart
class FlashcardListNotifier extends Notifier<List<Flashcard>> {
  @override
  List<Flashcard> build() {
    return flashcardList; // 初期値
  }

  void addCard(String question, String answer, Genre genre) {
    state = [
      ...state,
      Flashcard(id: state.length, question: question, answer: answer, genre: genre),
    ];
  }
}
```

### 覚えておくべきこと
- **`build()` が返す値が初期状態**になります（`StatefulWidget` の `initState` に近い役割）。
- 現在の値は **`state`** で読み書きします。
- 状態を変える処理（`addCard` など）は **Notifier クラスの中にメソッドとして書く**。画面側には「何をしたいか」だけ書けばよくなります。

### ⚠️ 最大のつまずきポイント：`state.add()` では画面が更新されない

```dart
// ❌ NG：中身は変わるが、画面は再描画されない
state.add(Flashcard(...));

// ✅ OK：新しいリストを作って state に「代入」する
state = [...state, Flashcard(...)];
```

Riverpod は **`state` に新しいオブジェクトが代入されたこと** で変更を検知します。
同じリストに `add` しても「同じオブジェクトのまま」なので変更に気づけません。
`...`（スプレッド演算子）で中身をコピーした **新しいリスト** を作るのが定石です。

> 削除なら `state = state.where((c) => c.id != id).toList();`、
> 更新なら `state = [for (final c in state) c.id == id ? 新しいカード : c];` のように、いつも「新しく作って代入」です。

### 補足：id の付け方
`id: state.length` は「追加しかしない」前提なら動きますが、**削除機能を追加すると id が重複する可能性**があります。将来的には「最大の id + 1」などにすると安全です。

---

## 4. 画面側：`ConsumerWidget`（StatelessWidget の置き換え）

```dart
class GenreListPage extends ConsumerWidget {
  const GenreListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genreList = ref.watch(genreProvider);
    ...
  }
}
```

### つまずきポイント
- `StatelessWidget` → **`ConsumerWidget`** に変えたら、`build` の引数に **`WidgetRef ref` を追加** する必要があります。忘れるとコンパイルエラーです。
- `ref` は「Provider にアクセスするための窓口」。`ref` がないと Provider は読めません。

### StatefulWidget → ConsumerWidget にしたケース（カード一覧画面）

カード一覧はもともと `StatefulWidget` でしたが、**状態は Provider が持つようになったので、画面自身が状態を持つ必要がなくなり** `ConsumerWidget` にできました。

```dart
// 変更前（State クラスの中）
widget.genre.id

// 変更後（ConsumerWidget なのでフィールドを直接参照）
genre.id
```

- `State` クラスがなくなるので **`widget.` が不要** になります。消し忘れるとエラーになるので注意。

---

## 5. 画面側：`ConsumerStatefulWidget`（StatefulWidget の置き換え）

カード追加画面は、フォームのキーや選択中のジャンル（`selectedValue`）など **画面固有の状態** があるので `StatefulWidget` のまま、Riverpod 版に置き換えています。

```dart
class CardAddPage extends ConsumerStatefulWidget {
  ...
  @override
  ConsumerState<CardAddPage> createState() => _CardAddState();
}

class _CardAddState extends ConsumerState<CardAddPage> {
  @override
  Widget build(BuildContext context) {   // ← WidgetRef ref は書かない！
    final genreList = ref.watch(genreProvider);
    ...
  }
}
```

### つまずきポイント
- 変えるのは **2 か所セット**：
  - `StatefulWidget` → `ConsumerStatefulWidget`
  - `State<T>` → `ConsumerState<T>`（`createState` の戻り値の型も）
- **`ConsumerState` の `build` には `WidgetRef ref` を書かない。**
  `ref` は `ConsumerState` のプロパティとして最初から使えます（`ConsumerWidget` との違い）。
  `initState` やボタンのコールバック内でも `ref` が使えます。

| | `ConsumerWidget` | `ConsumerState` |
| --- | --- | --- |
| build の引数 | `(BuildContext context, WidgetRef ref)` | `(BuildContext context)` |
| `ref` の入手 | 引数で受け取る | プロパティとして最初からある |

### 「Provider に置く状態」と「画面に置く状態」の線引き
- **複数画面で共有するデータ**（カード一覧） → Provider
- **その画面の中だけで使う一時的な値**（フォームのキー、ドロップダウンの選択値） → `State` のフィールドのままでOK

なんでも Provider に入れればいいわけではありません。

---

## 6. `ref.watch` と `ref.read` の使い分け（超重要）

```dart
// build の中：値を表示に使う → watch
final flashcardList = ref.watch(flashcardProvider);

// ボタンを押したとき：メソッドを呼ぶ → read
onPressed: () {
  ref.read(flashcardProvider.notifier).addCard(question, answer, genre);
  Navigator.of(context).pop();
},
```

| メソッド | 意味 | 使う場所 |
| --- | --- | --- |
| `ref.watch(p)` | 値を取得し、**変化したら再描画** | `build` メソッドの中 |
| `ref.read(p)` | その瞬間の値を **1 回だけ** 取得 | `onPressed` などのイベント処理の中 |

### つまずきポイント
- **`build` の中で `ref.read` を使うと、値が変わっても画面が更新されません。**
- **`onPressed` などのコールバックの中で `ref.watch` を使ってはいけません。**（不要な監視・予期しない動作の原因）
- **`.notifier` の有無**で取れるものが違います：
  - `ref.watch(flashcardProvider)` → `List<Flashcard>`（状態そのもの）
  - `ref.read(flashcardProvider.notifier)` → `FlashcardListNotifier`（メソッドを持つオブジェクト）
  - `addCard` は Notifier のメソッドなので **`.notifier` を付けないと呼べません**。

### 画面がつながって更新される流れ
1. カード追加画面で `ref.read(flashcardProvider.notifier).addCard(...)`
2. Notifier 内で `state = [...]` と新しいリストを代入
3. `ref.watch(flashcardProvider)` しているカード一覧画面が **自動で再描画**
4. `pop` で戻ると、追加されたカードがもう表示されている

以前のように「戻ったときに `setState` で再描画させる」ような工夫は不要になりました。

---

## 7. その他、今回の変更で直した細かいポイント

### `genreList[selectedValue]` → `firstWhere`
```dart
// 変更前：id とリストの添字(index)が一致している前提
final genre = genreList[selectedValue];

// 変更後：id で検索する
final genre = genreList.firstWhere((genre) => genre.id == selectedValue);
```
**id と index は別物**です。並び替えや削除があると一致しなくなるので、id で検索するのが安全です。

### for 文 → `map(...).toList()`
```dart
final dropdownMenuItemList = genreList.map((genre) {
  return DropdownMenuItem(value: genre.id, child: Text(genre.title));
}).toList();
```
`map` の戻り値は `Iterable` なので、`List` が必要な場所では **`.toList()` を忘れない** こと。

---

## 8. チェックリスト

- [ ] `flutter_riverpod` を追加して `flutter pub get` した
- [ ] `runApp` を `ProviderScope` で包んだ
- [ ] 変わらないデータは `Provider`、変わるデータは `NotifierProvider` にした
- [ ] Notifier では `state` に **新しいリストを代入** している（`state.add` していない）
- [ ] `StatelessWidget` → `ConsumerWidget` にして `build` に `WidgetRef ref` を追加した
- [ ] `StatefulWidget` → `ConsumerStatefulWidget` / `ConsumerState` に（`build` に `ref` は書かない）
- [ ] `build` の中は `ref.watch`、イベント処理の中は `ref.read`
- [ ] メソッドを呼ぶときは `.notifier` を付けた
- [ ] 画面から `data/` の import を消し、`providers.dart` 経由にした

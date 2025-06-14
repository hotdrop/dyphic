# Product Context

## プロジェクトの目的
ユーザーの日々の体調管理をするアプリです。日々の食事記録、お薬の服用記録、体調情報、ノート機能などを提供します。
家族にも共有したかったためデータはFirestoreへ保持しアプリをインストールしたユーザー全員が情報を見れるようにしています。

## 主要技術スタック
- Flutter
- Riverpod: 状態管理
- isar: ローカルストレージ
- Firebase: Authentication, Firestore, Crashlytics

## ディレクトリ構成
```
lib/
  common/       # 拡張メソッドやLoggerなどのユーティリティ
  model/        # RecordやMedicineなどのデータクラス
  repository/   # データ取得・保存を担うレイヤ
    local/      # Isar DB 関連。DAO と Entity を配置
    remote/     # Firestore API とFirestoreのCollection/Documentの定義
  service/      # Firebase ラッパー（Auth, Firestore, Crashlytics）
  ui/           # 各画面と対応するControllerを配置。RiverpodのProviderを介してRepositoryを利用する
    calender/   # カレンダー機能
    condition/  # 体調管理機能
    medicine/   # お薬管理機能
    note/       # ノート管理機能
    record/     # 日々の情報記録機能
      widgets/  # 記録画面でのみ使用する部品
    setting/    # アプリ設定機能
    widget/     # 複数の機能で再利用可能な部品
  res/          # テーマや画像定義など UI リソース
assets/         # 画像・JSON などの静的リソース
```

## アーキテクチャ概要
- `Repository`や`Service`は必ず`Provider`経由で注入します。
- `Repository`や`Service`は`Controller`から呼び出します。
- アプリ起動時は `initializerProvider` (`FutureProvider`) が Firebase 初期化とマスターデータ読み込みを行います。
  - 例: カレンダ画面では `CalendarController` が `recordRepositoryProvider` を利用して記録をロードし、選択状態を `StateProvider` で保持します。

### 状態管理ライブラリ Riverpod の使い方
- 画面(View)の状態管理には`Riverpod`を使います。
- Viewごとに1つのControllerクラスを作成します。ControllerクラスはRiverpodの`@riverpod`をつけます。
- 新しいControllerを作成して`@riverpod`をつけたり、Controllerでoverrideしているbuild関数の引数や戻り値の型を変更した場合、エラーになります。自動生成クラスの生成・更新をするため`flutter pub run build_runner build` で Riverpod の生成コードを作成します。(生成物は `.g.dart`)
- `@riverpod`をつけたControllerクラスにViewの状態やViewから呼び出すビジネスロジックを定義します。ただしControllerクラスのbuild関数にどうしても引数が必要な場合やViewの任意の場所でControllerクラスの関数を呼びたい場合、いちいち引数が必要になり面倒なため関数の集合体をProviderで定義します。例えば`lib/ui/medicine/edit/medicine_edit_controller.dart`では`_MedicineEditMethods`という関数のみのクラスを定義し`medicineEditMethodsProvider`で呼び出せるようにしています。
- `@riverpod`以外で利用可能なProviderは`StateProvider`、`Provider`、`FutureProvider`とします。これ以外は使用しません。特に`StateNotifierProvider`は使用してはいけません。

### UI ウィジェットの指針
- 1メソッドに長大なWidgetを並べず、Performanceを考慮して細かくprivateな`Class Widget`に切り出します。`Function Widget`は絶対に作成しません
- 可能な限り`StatelessWidget`を使い、RiverpodのクラスであるControllerやProviderにアクセスしたい場合は`ConsumerWidget`を使います。
- ラジオボタンやchipsなど細かいコンポーネントの状態管理をする場合は`StatefulWidget`を使います。
- 機能をまたがった複数レイアウトの共有部品は `lib/ui/widget` にまとめ、特定機能のレイアウトの共通部分は`lib/ui/xxx/widgets`にまとめ、ページ側では可読性を意識して構築します。

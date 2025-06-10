# Project Rules

このプロジェクトで Cline や Cursor などの AI コーディング支援ツールを利用する際の基本方針をまとめます。コードベースの概要もあわせて記載します。

## 主要コンポーネント
- `lib/common` : 拡張メソッドやロガーなどのユーティリティ
- `lib/model` : `Record` や `Medicine` などのデータクラス
- `lib/repository` : データ取得・保存を担うレイヤ。`local`(Isar) と `remote`(Firestore) を持つ
- `lib/service` : Firebase ラッパー（Auth, Firestore, Crashlytics）
- `lib/ui` : 各画面と対応する `Controller` を配置。Riverpod の Provider を介して Repository を利用する
- `lib/res` : テーマや画像定義など UI リソース
- `assets` : 画像・JSON などの静的リソース

## ディレクトリ構成
```
lib/
  common/
  model/
  repository/
    local/      # Isar DB 関連。DAO と Entity を配置
    remote/     # Firestore API とドキュメント定義
  service/
  ui/
    widget/     # 再利用可能な部品
  res/
assets/
  images/
  json/
  launcher/
```

## データフローと Riverpod
- 画面(View)ごとに 1 つの `Controller` クラスを作成し、`@riverpod` アノテーションで状態を管理します
- Provider は `StateProvider`、`Provider`、`FutureProvider` を中心に使用し、必要最小限に絞ります
- Repository や Service を Provider 経由で注入し、Controller から呼び出します
- アプリ起動時は `initializerProvider` (`FutureProvider`) が Firebase 初期化とマスターデータ読み込みを行います
- 例: カレンダ画面では `CalendarController` が `recordRepositoryProvider` を利用して記録をロードし、選択状態を `StateProvider` で保持します

## UI ウィジェットの指針
- Widget は必ずクラス (`StatelessWidget` 等) として実装し、関数 Widget は作成しません
- 1 メソッドに長大な Widget を並べず、小さな private クラスやメソッドに分割します
- レイアウトの共有部品は `lib/ui/widget` にまとめ、ページ側では可読性を意識して構築します

## 開発時のポイント
- Firebase 用の設定ファイル (`firebase_options.dart` など) は環境依存のため git 管理外です。必要に応じて生成してください
- `flutter pub run build_runner build` で Riverpod の生成コードを作成します (生成物は `.g.dart`)
- ルートの `README.md` にビルド方法や TODO が記載されているので参照してください
- テストは `test/` ディレクトリに配置します。現在はサンプルのみなので充実させる余地があります

## コーディング規約
- `analysis_options.yaml` で `flutter_lints` を基準とし、以下を追加
  - `avoid_print: true`
  - `prefer_single_quotes: true`
  - `unnecessary_overrides: false`
- 生成ファイル (`*.g.dart`, `*.freezed.dart`) は解析対象から除外
- コード整形には `dart format` を用いる

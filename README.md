# dyphic
日々の体調管理をするために作成したアプリです。このアプリはFirebaseを利用しています。  

# 画面イメージ
サンプル画像  
<img src="images/01_calendar.png" width="200" />
<img src="images/02_condition.png" width="200" />

# お薬情報の画像について
`Firebase Storage`の有料化に伴い、使えなくなったのでローカルで固定にします。
`/assets/images/medicines/`ディレクトリの中に`[id].jpeg`というファイルを置くと自動で読み込みます。

# 利用サービス
- FirebaseAuth
  - 認証機能で`Sign-in method`のGoogleを有効にしています。未ログインの場合はデータの閲覧のみ許容し、ログインしていると各データの登録/編集を可能にしています。
- Firestore
  - 初期値は不要です。アプリで保存したデータを登録・更新します。
- Crashlytics

# command
```
// build
flutter build apk --release --split-per-abi
flutter build appbundle
```

# TODO 機能開発/修正
- カレンダーと記録ページ
  - カレンダーから記録ページに遷移し、記録ページの左右スワイプで日付を移動できる。この機能を実現するための実装方法が性能面や可読性で問題ないか確認し、必要に応じて修正する。
  - カレンダーから記録ページに遷移し、いくつか記録情報を編集してカレンダーに戻ってきたとき、今は`calendar_page.dart`の`_ViewSelectedDayInfoCard`でコントローラの`onLoadRecords`を実行しているが、これは無駄な処理。大体は1、2箇所の記録データしか更新しないので、更新したRecordのidをリストで保持しておき、`CalendarController`の`refresh`で1つずつ更新した方がいい。
- お薬ページ
  - `expansion_tile_card`がカタつくのでライブラリを使わず自作して解消したい
  - 今使っている薬と今は服用していない薬の2択を区別できるようにして、それを記録入力画面では「今服用していない薬」をExpanded/collespondで閉じるようにしたい
  - 一覧でリストのアイテムを並び替えられるようにしてorderを更新する。記録入力画面で並び順を反映する

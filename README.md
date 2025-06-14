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

# AAB作成
```
flutter build appbundle
```

# TODO 機能開発/修正
- お薬ページ
  - 一覧でリストのアイテムを並び替えられるようにしてorderを更新する。記録入力画面で並び順を反映する
- カレンダー機能
  - カレンダーから記録ページに遷移し、いくつか記録情報を編集してカレンダーに戻ってきたとき、今は`calendar_page.dart`の`_ViewSelectedDayInfoCard`でコントローラの`onLoadRecords`を実行しているがこれは無駄な処理。大体は1、2箇所の記録データしか更新しないので更新したRecordのidをリストで保持しておき`CalendarController`の`refresh`で1つずつ更新した方が効率が良いと思う。
# dyphic
日々の体調管理をするために作成したアプリです。このアプリはFirebaseを利用しています。  

# 画面イメージ
サンプル画像  
<img src="images/01_calendar.png" width="200" />
<img src="images/02_note.png" width="200" />
<img src="images/03_note_edit.png" width="200" />
<img src="images/04_setting.png" width="200" />  

# command
```
// build
flutter build apk --release --split-per-abi
flutter build appbundle
```

## FirebaseAuth
認証機能で`Sign-in method`のGoogleを有効にしています。  
未ログインの場合はデータの閲覧のみ許容し、ログインしていると各データの登録/編集を可能にしています。
実際にはアプリの実装と各サービスのルールで制御しています。

## Firestore
初期値は不要です。アプリで保存したデータを登録・更新します。  

## Crashlytics
リリースビルドで作ったアプリでCrashlyticsへレポートを送信するようにしているので、有効にすることでクラッシュ情報がみれます。

# やること
- BottomNavigationMenuにお薬を追加する
- お薬の画像はローカルから取得する。png画像はID
  - medicineのidで、ローカルから`/medicine/images/[id].png`の画像を取得。あれば表示する
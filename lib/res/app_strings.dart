class AppStrings {
  AppStrings._();

  // 記録ページ
  static const String recordPageTitleDateFormat = 'yyyy年MM月dd日';
  static const String recordMorningDialogTitle = '朝食';
  static const String recordLunchDialogTitle = '昼食';
  static const String recordDinnerDialogTitle = '夕食';
  static const String recordMealDialogHint = '食事の内容(簡単に)';

  static const String recordMedicalTitle = '服用した薬';
  static const String recordMedicineSaveButton = '選択した薬を保存する';

  static const String recordConditionTitle = '体調';
  static const String recordWalkingLabel = '🚶‍♀️散歩';
  static const String recordToiletLabel = '💩排便';
  static const String recordConditionMemoTitle = '体調メモ';
  static const String recordConditionMemoHint = '細かい体調はこちらに記載しましょう！';
  static const String recordConditionSaveButton = '体調情報を保存する';

  static const String recordEventLabel = '予定名（放射線科、婦人科など）';
  static const String recordEventSaveButton = '予定を保存する';

  static const String recordMemoTitle = '今日のメモ';
  static const String recordMemoHint = 'その他、残しておきたい記録があったらここに記載してください。';
  static const String recordMemoSaveButton = 'メモを保存する';

  // 設定ページ
  static const String settingsPageTitle = '設定';
  static const String settingsNotSignInEmailLabel = '未ログイン';
  static const String settingsNotSignInNameLabel = 'ー';
  static const String settingsLoginInfo = '※Googleアカウントでログインできます。ログインすると各データの登録/編集が可能になります。';
  static const String settingsLoginNameNotSettingLabel = '未設定';
  static const String settingsLoginEmailNotSettingLabel = '未設定';
  static const String settingsLoginWithGoogle = 'ログイン';
  static const String settingsLogoutLabel = 'ログアウト';
  static const String settingsLicenseLabel = 'ライセンス';
  static const String settingsChangeAppThemeLabel = 'テーマ切り替え';
  static const String settingsEditConditionLabel = '体調情報';
  static const String settingsEditConditionSubLabel = 'タップで体調情報を表示します。';
  static const String settingsEditMedicineLabel = 'お薬情報';
  static const String settingsEditMedicineSubLabel = 'タップでお薬情報を表示します。';
  static const String settingsLoadEventConfirmMessage = 'サーバーから最新のイベント情報を取得します。\nよろしいですか？';
  static const String settingsLoadRecordLabel = '記録情報を再取得';
  static const String settingsLoadRecordSubLabel = 'タップで日々の記録情報を最新化します。';
  static const String settingsLoadRecordConfirmMessage = 'サーバーから最新の記録情報を取得します。\nよろしいですか？\n\n※注意！\nこの操作は通常行う必要はありません。他の人がデータを更新した場合に実行してください。';
  static const String settingsLoadNoteLabel = 'ノート情報を再取得';
  static const String settingsLoadNoteSubLabel = 'タップでノート情報を最新化します。';
  static const String settingsLoadNoteConfirmMessage = 'サーバーから最新のノート情報を取得します。\nよろしいですか？';
}

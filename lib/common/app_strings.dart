class AppStrings {
  AppStrings._();

  static const String appTitle = '体調管理';

  static const String calenderPageTitle = 'カレンダー';
  static const String calenderNoEvent = '予定なし';
  static const String calenderUnRegisterLabel = 'この日の記録は未登録です。\nここをタップして記録しましょう。';
  static const String calenderDetailConditionLabel = '【体調】';
  static const String calenderDetailConditionMemoLabel = '【体調メモ】';

  static const String recordPageTitleDateFormat = 'yyyy年MM月dd日';
  static const String recordMorningDialogTitle = '朝食';
  static const String recordLunchDialogTitle = '昼食';
  static const String recordDinnerDialogTitle = '夕食';
  static const String recordMealDialogHint = '食事の内容(簡単に)';
  static const String recordTemperatureMorning = '朝の体温';
  static const String recordTemperatureNight = '夜の体温';
  static const String recordTemperatureUnit = '度';
  static const String recordTemperatureNonSet = '未登録';
  static const String recordMedicalTitle = '服用した薬';
  static const String recordConditionTitle = '体調';
  static const String recordConditionMemoTitle = '体調メモ';
  static const String recordConditionMemoHint = '細かい体調はこちらに記載しましょう！';
  static const String recordMemoTitle = '今日のメモ';
  static const String recordMemoHint = 'その他、残しておきたい記録があったらここに記載してください。';

  static const String medicinePageTitle = 'お薬';
  static const String medicinePageNothingItemLabel = 'お薬が登録されていません。\nログインしてお薬を登録しましょう。';
  static const String medicinePageOralName = '内服薬';
  static const String medicinePageNotOralName = '頓服薬';
  static const String medicinePageTypeIntravenousName = '点滴';
  static const String medicineEditPageTitle = 'お薬情報';
  static const String medicineNameLabel = 'お薬名';
  static const String medicineOverviewLabel = '一言メモ';
  static const String medicineOralLabel = '内服薬';
  static const String medicineNotOralLabel = '頓服薬';
  static const String medicineImageOverviewLabel = 'カメラボタンでお薬の写真を撮ってください。';
  static const String medicineStartCameraLabel = 'カメラを起動する';
  static const String medicineMemoLabel = '詳細メモ';
  static const String medicineMemoHint = '詳細な情報を残したい場合はここに記載してください。';
  static const String medicineSaveButton = 'この内容で保存する';
  static const String medicineNotSaveAttention = 'お薬の名前が未入力です。';

  static const String conditionPageTitle = '体調管理';
  static const String conditionOverview = 'この画面では体調に関する症状を登録・編集できます。';
  static const String conditionDetail = '「頭痛」や「腹痛」など大まかな症状を登録し、細かい症状は日々の記録画面にある体調メモに書いていくことをオススメします。';
  static const String conditionClearSelectedLabel = '選択をクリアする';
  static const String conditionInputLabel = '症状名';
  static const String conditionInputDuplicateMessage = 'この症状名は既に登録されています。';
  static const String conditionNewButton = '新しく登録する';
  static const String conditionEditButton = '症状名を修正する';

  static const String settingsPageTitle = '設定';
  static const String settingsNotLoginEmailLabel = '未ログイン';
  static const String settingsNotLoginNameLabel = 'ー';
  static const String settingsLoginInfo = '※Googleアカウントでログインできます。ログインすると各データの登録/編集が可能になります。';
  static const String settingsLoginNameNotSettingLabel = '未設定';
  static const String settingsLoginEmailNotSettingLabel = '未設定';
  static const String settingsLoginWithGoogle = 'ログイン';
  static const String settingsLogoutLabel = 'ログアウト';
  static const String settingsChangeAppThemeLabel = 'テーマ切り替え';
  static const String settingsEditConditionLabel = '体調情報';
  static const String settingsEditConditionSubLabel = 'タップで体調情報を表示します。';
  static const String settingsEditMedicineLabel = 'お薬情報';
  static const String settingsEditMedicineSubLabel = 'タップでお薬情報を表示します。';
  static const String settingsAppVersionLabel = 'アプリバージョン';

  static const String textFieldRequiredEmptyError = '※必須項目';

  static const String dialogSuccessMessage = '処理が完了しました！';
  static const String dialogErrorMessage = 'エラーが発生しました(´·ω·`)';
  static const String dialogOk = 'OK';
  static const String dialogCancel = 'キャンセル';
}

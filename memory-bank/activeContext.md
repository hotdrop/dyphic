# Active Context

## 必ず守ること(編集禁止)
現在のタスクに書かれた内容は必ず1つずつ「Plan/Act」を経てユーザーに確認しながら実装すること。Planで実装計画を立てた後、Actで実装に入った場合「現在のタスク」に列挙されたタスクを一度に全部こなしてはいけません。必ず1つずつPlan→Actを行い、1つ完了したらユーザーに確認し、Planで再び実装計画から行ってください。

## 実装計画
`RecordPage`のスワイプ機能を、選択日の前後1ヶ月に限定することで、UIの応答性を改善し、不要なデータ生成を抑制します。カレンダー自体のマーカー表示（全期間）は維持します。

### 計画概要
1.  **`onDaySelected`のロジック修正**: `CalendarController`にて、未来日が選択された場合に`calendarRecordsMapStateProvder`に不要な空データを追加する処理を停止します。
2.  **`_onTap`のロジック修正**: `CalendarPage`にて、`RecordsPageView`へ渡すIDのリストを、全期間から「選択日の前後1ヶ月」に限定するよう動的に生成するロジックに変更します。

## 現在のタスク
- [x] **`CalendarController`の修正**
    - [x] `lib/ui/calender/calendar_controller.dart` の `onDaySelected` メソッドを修正し、未来日を選択した際に`calendarRecordsMapStateProvder`に空の`Record`が追加されないようにする。
- [x] **`CalendarPage`の修正**
    - [x] `lib/ui/calender/calendar_page.dart` の `_onTap` メソッドを修正し、`RecordsPageView`に渡すIDリストが、選択された日付の前後1ヶ月分になるように動的に生成する。
        - 生成するIDリストには、必ず**選択された日付のIDが含まれる**ようにする。
        - `RecordsPageView.start` を呼び出す際、生成したリスト内での選択中IDのインデックスを `selectedIndex` として正しく渡す。

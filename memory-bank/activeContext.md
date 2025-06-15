# Active Context

## 必ず守ること(編集禁止)
現在のタスクに書かれた内容は必ず1つずつ「Plan/Act」を経てユーザーに確認しながら実装すること。Planで実装計画を立てた後、Actで実装に入った場合「現在のタスク」に列挙されたタスクを一度に全部こなしてはいけません。必ず1つずつPlan→Actを行い、1つ完了したらユーザーに確認し、Planで再び実装計画から行ってください。

## 実装計画
`nextTask.md`に記載された2つのバグを修正します。

### 計画概要
1.  **[完了] バグ修正1：カレンダーの体温アイコン表示**
    - `lib/ui/calender/calendar_page.dart` を修正しました。
    - `_ViewMarker` クラスの `_buildMarker` メソッド内で、体温 (`morningTemperature`) が `0.0` より大きい場合にのみ体温計アイコンが表示されるように、条件式を修正しました。
2.  **[完了] バグ修正2：記録画面のフォーカス**
    - `lib/ui/record/record_page.dart` を修正しました。
    - `_processSaveCondition` 関数を対象に、保存ボタンをタップした際にキーボードが閉じるように修正しました。
    - `FocusScope.of(context).unfocus()` の代わりに、より確実なフォーカス解除処理を実装しました。
    - `_processSaveMedicine`, `_processSaveMemo`, `_processSaveEvent` の3つの関数にも同様の修正を適用しました。

## 現在のタスク
- [x] `lib/ui/calender/calendar_page.dart` の `_buildMarker` メソッドを修正し、体温が0.0より大きい場合のみアイコンが表示されるようにする。
- [x] `lib/ui/record/record_page.dart` の `_processSaveCondition` 関数を修正し、保存後にキーボードが閉じるようにする。
- [x] `lib/ui/record/record_page.dart` の `_processSaveMedicine` 関数を修正し、保存後にキーボードが閉じるようにする。
- [x] `lib/ui/record/record_page.dart` の `_processSaveMemo` 関数を修正し、保存後にキーボードが閉じるようにする。
- [x] `lib/ui/record/record_page.dart` の `_processSaveEvent` 関数を修正し、保存後にキーボードが閉じるようにする。

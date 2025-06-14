# Active Context

## 必ず守ること(編集禁止)
現在のタスクに書かれた内容は必ず1つずつ「Plan/Act」を経てユーザーに確認しながら実装すること。Planで実装計画を立てた後、Actで実装に入った場合「現在のタスク」に列挙されたタスクを一度に全部こなしてはいけません。必ず1つずつPlan→Actを行い、1つ完了したらユーザーに確認し、Planで再び実装計画から行ってください。

## 実装計画
記録画面のお薬選択UIについて、普段服用しない薬は初回表示では折りたたんでおく機能を実装する。

### 計画概要
1.  **データモデルの更新:** `Medicine` と `MedicineEntity` に表示設定用の `isDefault` フラグを追加する。
2.  **お薬設定UIの追加:** お薬一覧画面 (`medicine_page.dart`) で、各お薬の `isDefault` を切り替えるUI (`Switch`) を追加する。
3.  **記録画面の改修:** 記録画面 (`record_page.dart`) のお薬選択UI (`chips_medicine.dart`) を改修し、`isDefault` フラグに応じて表示を分ける。`false` のものは `ExpansionTile` で初期非表示にする。
4.  **リポジトリ/DAOの更新:** `isDefault` フラグをローカルDB (Isar) で更新するためのメソッドを追加する。
5.  **コード生成:** Isarのエンティティ変更に伴い、`build_runner` を実行する。

## 現在のタスク
- [x] `lib/repository/local/entity/medicine_entity.dart` に `isDefault` フィールドを追加する。
- [x] `lib/model/medicine.dart` に `isDefault` フィールドを追加する。
- [x] `lib/repository/local/dao/medicine_dao.dart` のマッピング処理を更新する。
- [x] `build_runner` を実行して `*.g.dart` を更新する。

# このファイルについて
この`nextTask.md`はタスクの仕様をユーザーが詳細に記載します。更新はしないでください。

# やりたいこと
以下の2つのバグを修正したい。

1. 記録画面で体温を1度でも登録してしまうと、その後体温を0で登録してもカレンダー画面に体温アイコンが表示されてしまう。0度で登録した場合はカレンダーに体温計アイコンを表示しないでほしい
2. 記録画面で体調メモやメモなどTextFieldに文字を入力した後、Enterを押さずソフトキーボードが表示された状態のまま「保存」ボタンを押すと、保存処理は完了するのだが、そのまま`TextField`にフォーカスが当たり続けソフトキーボードも表示されたままになる。保存処理が完了したらフォーカスアウトしてソフトキーボードを閉じてほしい

# 補足事項
1のバグについて、体温計アイコンは`calendar_page.dart`の`_ViewMarker`Widgetクラスの`_buildMarker`関数で表示処理を行っている。ここの`morningTemperature`の判定処理を修正すれば良いと思う。
2のバグについては少し厄介である。該当処理は`record_page.dart`の以下の4つの関数で全て作りは同じ。
- `_processSaveCondition`関数
- `_processSaveMedicine`関数
- `_processSaveMemo`関数
- `_processSaveEvent`関数
まず`_processSaveCondition`関数でうまく動作すれば他の関数に横展開できるので、`_processSaveCondition`関数で修正を試みてほしい。なお、既存コードに`FocusScope.of(context).unfocus()`という処理を入れているが、この処理でフォーカスが外れないようだ。
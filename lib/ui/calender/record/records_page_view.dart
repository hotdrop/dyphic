import 'package:flutter/material.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/ui/calender/record/record_page.dart';

///
/// 記録ページはここから呼ぶ
///
class RecordsPageView extends StatelessWidget {
  const RecordsPageView._(this._records, this._selectedIndex);

  static Future<void> start(
    BuildContext context, {
    required List<Record> records,
    required int selectedIndex,
  }) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => RecordsPageView._(records, selectedIndex)),
    );
  }

  final List<Record> _records;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: _selectedIndex, keepPage: false);
    return PageView.builder(
      controller: controller,
      itemCount: _records.length,
      itemBuilder: (ctx, index) => RecordPage(_records[index]),
    );
  }
}

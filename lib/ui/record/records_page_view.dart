import 'package:flutter/material.dart';
import 'package:dyphic/ui/record/record_page.dart';

///
/// 記録ページはここから呼ぶ
///
class RecordsPageView extends StatelessWidget {
  const RecordsPageView._(this._recordIds, this._selectedIndex);

  static Future<void> start(BuildContext context, {required List<int> recordIds, required int selectedIndex}) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => RecordsPageView._(recordIds, selectedIndex)),
    );
  }

  final List<int> _recordIds;
  final int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: _selectedIndex, keepPage: false);
    return PageView.builder(
      controller: controller,
      itemCount: _recordIds.length,
      itemBuilder: (ctx, index) => RecordPage(_recordIds[index]),
    );
  }
}

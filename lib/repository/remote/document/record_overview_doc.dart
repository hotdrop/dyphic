class RecordOverviewDoc {
  const RecordOverviewDoc({
    required this.recordId,
    required this.isWalking,
    required this.isToilet,
    required this.conditionStringIds,
    required this.conditionMemo,
  });

  final int recordId;
  final bool isWalking;
  final bool isToilet;
  final String conditionStringIds;
  final String conditionMemo;
}

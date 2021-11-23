class RecordDetailDoc {
  const RecordDetailDoc({
    required this.recordId,
    required this.medicineStrIds,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.memo,
  });

  final int recordId;
  final String medicineStrIds;
  final String breakfast;
  final String lunch;
  final String dinner;
  final String memo;
}

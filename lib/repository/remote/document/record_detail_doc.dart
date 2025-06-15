import 'package:dyphic/model/record.dart';

class RecordDetailDoc {
  const RecordDetailDoc({
    required this.recordId,
    required this.medicineStrIds,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.eventType,
    required this.eventName,
    required this.memo,
  });

  final int recordId;
  final String medicineStrIds;
  final String breakfast;
  final String lunch;
  final String dinner;
  final EventType eventType;
  final String eventName;
  final String memo;
}

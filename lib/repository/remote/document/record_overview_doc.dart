import 'package:dyphic/model/record.dart';

class RecordOverviewDoc {
  const RecordOverviewDoc({
    required this.recordId,
    required this.isWalking,
    required this.isToilet,
    required this.conditionStringIds,
    required this.conditionMemo,
    required this.eventType,
    required this.eventName,
  });

  final int recordId;
  final bool isWalking;
  final bool isToilet;
  final String conditionStringIds;
  final String conditionMemo;
  final EventType eventType;
  final String eventName;
}

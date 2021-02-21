import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class RecordViewModel extends NotifierViewModel {
  RecordViewModel._(this.date, this._repository);

  factory RecordViewModel.create(DateTime date) {
    return RecordViewModel._(date, RecordRepository.create());
  }

  final DateTime date;
  final RecordRepository _repository;

  Record _record;
  Record get record => _record;

  Future<void> init() async {
    _record = await _repository.find(date);
    loadSuccess();
  }
}

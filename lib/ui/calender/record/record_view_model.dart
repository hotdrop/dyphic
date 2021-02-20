import 'package:dyphic/model/record.dart';
import 'package:dyphic/repository/record_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class RecordViewModel extends NotifierViewModel {
  RecordViewModel._(this.id, this._repository);

  factory RecordViewModel.create(int id) {
    return RecordViewModel._(id, RecordRepository.create());
  }

  final int id;
  final RecordRepository _repository;

  Record _record;
  Record get record => _record;

  Future<void> init() async {
    _record = await _repository.find(id);
    loadSuccess();
  }
}

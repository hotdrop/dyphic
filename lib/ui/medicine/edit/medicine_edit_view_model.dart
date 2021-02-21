import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class MedicineEditViewModel extends NotifierViewModel {
  MedicineEditViewModel._(this._originalMedicine, this._repository) {
    _init();
  }

  factory MedicineEditViewModel.create(Medicine medicine, {MedicineRepository argRepo}) {
    final repo = argRepo ?? MedicineRepository.create();
    return MedicineEditViewModel._(medicine, repo);
  }

  final MedicineRepository _repository;

  Medicine _originalMedicine;

  _InputItem _inputItem;
  String get imageFilePath => _inputItem.imagePath;
  bool get canSave => _inputItem.isCompletedRequiredFields();

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void _init() {
    _inputItem = _InputItem.create(_originalMedicine);
    loadSuccess();
  }

  void inputName(String name) {
    _inputItem.name = name;
  }

  void inputOral(bool isOral) {
    _inputItem.isOral = isOral;
  }

  void inputImagePath(String path) {
    _inputItem.imagePath = path;
  }

  void inputMemo(String memo) {
    _inputItem.memo = memo;
  }

  Future<bool> save() async {
    final medicine = Medicine(
      name: _inputItem.name,
      isOral: _inputItem.isOral,
      memo: _inputItem.memo,
      imagePath: _inputItem.imagePath,
      order: _inputItem.order,
    );

    try {
      await _repository.save(medicine);
      return true;
    } catch (e, s) {
      await AppLogger.e('お薬情報の保存に失敗しました。', e, s);
      _errorMessage = '$e';
      return false;
    }
  }
}

///
/// 入力保持用のクラス
///
class _InputItem {
  _InputItem._(this.name, this.isOral, this.memo, this.imagePath, this.order);

  factory _InputItem.create(Medicine item) {
    return _InputItem._(item.name, item.isOral, item.memo, item.imagePath, item.order);
  }

  String name;
  bool isOral;
  String memo;
  String imagePath;
  int order;

  bool isCompletedRequiredFields() {
    return name != null && name.isNotEmpty;
  }
}

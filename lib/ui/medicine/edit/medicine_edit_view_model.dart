import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/ui/notifier_view_model.dart';

class MedicineEditViewModel extends NotifierViewModel {
  MedicineEditViewModel._(this._originalMedicine, this._repository) {
    _init();
  }

  factory MedicineEditViewModel.create(Medicine medicine) {
    return MedicineEditViewModel._(medicine, MedicineRepository.create());
  }

  final MedicineRepository _repository;

  Medicine _originalMedicine;

  _InputItem _inputItem;
  String get imageFilePath => _inputItem.localImagePath;
  bool get canSave => _inputItem.isCompletedRequiredFields();

  void _init() {
    _inputItem = _InputItem.create(_originalMedicine);
    loadSuccess();
  }

  void inputName(String name) {
    _inputItem.name = name;
  }

  void inputOverview(String overview) {
    _inputItem.overview = overview;
  }

  void inputOral(MedicineType type) {
    _inputItem.type = type;
  }

  void inputImagePath(String path) {
    _inputItem.localImagePath = path;
    notifyListeners();
  }

  void inputMemo(String memo) {
    _inputItem.memo = memo;
  }

  Future<bool> save() async {
    final medicine = Medicine(
      id: _originalMedicine.id,
      name: _inputItem.name,
      overview: _inputItem.overview,
      type: _inputItem.type,
      memo: _inputItem.memo,
      imagePath: _inputItem.localImagePath,
      order: _originalMedicine.order,
    );

    try {
      bool isUpdateImage = (_originalMedicine.imagePath != _inputItem.localImagePath);
      await _repository.save(medicine, isUpdateImage);
      return true;
    } catch (e, s) {
      await AppLogger.e('お薬情報の保存に失敗しました。', e, s);
      return false;
    }
  }
}

///
/// 入力保持用のクラス
///
class _InputItem {
  _InputItem._(this.name, this.overview, this.type, this.memo, this.localImagePath);

  factory _InputItem.create(Medicine item) {
    return _InputItem._(item.name, item.overview, item.type, item.memo, item.imagePath);
  }

  String name;
  String overview;
  MedicineType type;
  String memo;
  String localImagePath;

  bool isCompletedRequiredFields() {
    return name != null && name.isNotEmpty;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/ui/base_view_model.dart';

final medicineEditViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _MedicineEditViewModel(ref.read));

class _MedicineEditViewModel extends BaseViewModel {
  _MedicineEditViewModel(this._read);

  final Reader _read;

  late _InputItem _inputItem;
  String get imageFilePath => _inputItem.localImagePath;
  bool get canSave => _inputItem.isCompletedRequiredFields();

  void init(Medicine medicine) {
    _inputItem = _InputItem.create(medicine);
    onSuccess();
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

  Future<void> save() async {
    final medicine = _inputItem.toMedicine();
    try {
      await _read(medicineProvider.notifier).save(medicine, _inputItem.isChageImagePath());
    } catch (e, s) {
      await AppLogger.e('お薬情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

///
/// 入力保持用のクラス
///
class _InputItem {
  _InputItem._(
    this.id,
    this.name,
    this.overview,
    this.type,
    this.memo,
    this.localImagePath,
    this.order,
    this.originalImagePath,
  );

  factory _InputItem.create(Medicine m) {
    return _InputItem._(m.id, m.name, m.overview, m.type, m.memo, m.imagePath, m.order, m.imagePath);
  }

  int id;
  String name;
  String overview;
  MedicineType type;
  String memo;
  String localImagePath;
  int order;
  final String originalImagePath;

  bool isCompletedRequiredFields() {
    return name.isNotEmpty;
  }

  bool isChageImagePath() {
    return originalImagePath != localImagePath;
  }

  Medicine toMedicine() {
    return Medicine(
      id: id,
      name: name,
      overview: overview,
      type: type,
      memo: memo,
      imagePath: localImagePath,
      order: order,
    );
  }
}

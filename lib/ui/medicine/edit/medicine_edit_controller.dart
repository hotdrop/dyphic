import 'package:dyphic/repository/medicine_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/medicine.dart';

part 'medicine_edit_controller.g.dart';

@riverpod
class MedicineEditController extends _$MedicineEditController {
  @override
  Future<void> build(int id) async {
    final target = await ref.read(medicineRepositoryProvider).find(id);
    final uiState = (target == null) ? _UiState.createEmpty(id: id) : _UiState.create(target);
    ref.read(medicineUiStateProvider.notifier).state = uiState;
  }
}

final medicineEditMethodsProvider = Provider((ref) => _MedicineEditMethods(ref));

class _MedicineEditMethods {
  const _MedicineEditMethods(this.ref);

  final Ref ref;

  void inputName(String newVal) {
    ref.read(medicineUiStateProvider.notifier).update(
          (state) => state.copyWith(name: newVal),
        );
  }

  void inputOverview(String newVal) {
    ref.read(medicineUiStateProvider.notifier).update(
          (state) => state.copyWith(overview: newVal),
        );
  }

  void inputOral(MedicineType newVal) {
    ref.read(medicineUiStateProvider.notifier).update(
          (state) => state.copyWith(type: newVal),
        );
  }

  void inputMemo(String newVal) {
    ref.read(medicineUiStateProvider.notifier).update(
          (state) => state.copyWith(memo: newVal),
        );
  }

  Future<void> save() async {
    try {
      final medicine = ref.read(medicineUiStateProvider).toMedicine();
      await ref.read(medicineRepositoryProvider).save(medicine);
    } catch (e, s) {
      await AppLogger.e('お薬情報の保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

final medicineUiStateProvider = StateProvider<_UiState>((_) => _UiState.createEmpty());

// お薬情報の登録可能条件。これがtrueになれば登録ボタンを押せる
final canSaveMedicineEditStateProvider = Provider<bool>((ref) {
  final name = ref.watch(medicineUiStateProvider).name;
  return name.isNotEmpty;
});

///
/// 入力保持用のクラス
///
class _UiState {
  _UiState({
    required this.id,
    required this.name,
    required this.overview,
    required this.type,
    required this.memo,
    required this.order,
  });

  factory _UiState.create(Medicine m) {
    return _UiState(
      id: m.id,
      name: m.name,
      overview: m.overview,
      type: m.type,
      memo: m.memo,
      order: m.order,
    );
  }

  factory _UiState.createEmpty({int id = -1}) {
    return _UiState(
      id: id,
      name: '',
      overview: '',
      type: MedicineType.intravenous,
      memo: '',
      order: id,
    );
  }

  final int id;
  final String name;
  final String overview;
  final MedicineType type;
  final String memo;
  final int order;

  Medicine toMedicine() {
    return Medicine(
      id: id,
      name: name,
      overview: overview,
      type: type,
      memo: memo,
      order: order,
    );
  }

  _UiState copyWith({
    String? name,
    String? overview,
    MedicineType? type,
    String? memo,
    int? order,
  }) {
    return _UiState(
      id: id,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      type: type ?? this.type,
      memo: memo ?? this.memo,
      order: order ?? this.order,
    );
  }
}

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/model/medicine.dart';
import 'package:dyphic/repository/medicine_repository.dart';

part 'medicine_controller.g.dart';

@riverpod
class MedicineController extends _$MedicineController {
  @override
  Future<void> build() async {
    await onLoad();
  }

  Future<void> onLoad() async {
    final medicines = await ref.read(medicineRepositoryProvider).findAll();
    ref.read(medicineUiStateProvider.notifier).state = medicines;
  }

  Future<void> refresh() async {
    await ref.read(medicineRepositoryProvider).onLoadLatest();
    await onLoad();
  }

  int createNewId() {
    final medicines = ref.read(medicineUiStateProvider);
    return (medicines.isNotEmpty) ? medicines.map((e) => e.id).reduce(max) + 1 : 1;
  }
}

final medicineUiStateProvider = StateProvider<List<Medicine>>((_) => []);

// スクロールでFabの表示非表示を切り替える
final isShowFabStateProvider = StateProvider<bool>((_) => false);

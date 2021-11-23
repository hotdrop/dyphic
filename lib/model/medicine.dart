import 'dart:math';

import 'package:dyphic/repository/medicine_repository.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicineProvider = StateNotifierProvider<_MedicineNotifier, List<Medicine>>((ref) => _MedicineNotifier(ref.read));

class _MedicineNotifier extends StateNotifier<List<Medicine>> {
  _MedicineNotifier(this._read) : super([]);

  final Reader _read;

  Future<void> onLoad() async {
    state = await _read(medicineRepositoryProvider).findAll(isForceUpdate: false);
  }

  Future<void> refresh() async {
    state = await _read(medicineRepositoryProvider).findAll(isForceUpdate: true);
  }

  Future<void> save(Medicine medicine, bool isUpdateImage) async {
    await _read(medicineRepositoryProvider).save(medicine, isUpdateImage);
    await onLoad();
  }

  Medicine newMedicine() {
    return Medicine.createEmpty(_createNewId(), _createNewOrder());
  }

  int _createNewId() {
    return (state.isNotEmpty) ? state.map((e) => e.id).reduce(max) + 1 : 1;
  }

  int _createNewOrder() {
    return (state.isNotEmpty) ? state.map((e) => e.order).reduce(max) + 1 : 1;
  }
}

class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.overview,
    required this.type,
    this.memo = '',
    this.imagePath = '',
    required this.order,
  });

  factory Medicine.createEmpty(int id, int order) {
    return Medicine(
      id: id,
      name: '',
      overview: '',
      type: MedicineType.oral,
      memo: '',
      imagePath: '',
      order: order,
    );
  }

  final int id;
  final String name;
  final String overview;
  final MedicineType type;
  final String memo;
  final String imagePath;
  final int order;

  Medicine copyWith({required String imageUrl}) {
    return Medicine(
      id: id,
      name: name,
      overview: overview,
      type: type,
      order: order,
      memo: memo,
      imagePath: imageUrl,
    );
  }

  String toTypeString() {
    switch (type) {
      case MedicineType.oral:
        return AppStrings.medicinePageOralName;
      case MedicineType.notOral:
        return AppStrings.medicinePageNotOralName;
      case MedicineType.intravenous:
        return AppStrings.medicinePageTypeIntravenousName;
      default:
        return '';
    }
  }

  @override
  String toString() {
    return '''
    id: $id
    name: $name
    overview: $overview
    type: ${toTypeString()}
    memo: $memo
    imagePath: $imagePath
    order: $order
    ''';
  }

  static MedicineType toType(int index) {
    if (index == MedicineType.oral.index) {
      return MedicineType.oral;
    } else if (index == MedicineType.notOral.index) {
      return MedicineType.notOral;
    } else {
      return MedicineType.intravenous;
    }
  }
}

enum MedicineType { oral, notOral, intravenous }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyphic/model/condition.dart';
import 'package:dyphic/model/medicine.dart';

mixin AppFirestoreMixin {
  static final String _recordRootName = 'records';
  static final String _medicineRootName = 'medicines';
  static final String _conditionRootName = 'conditions';

  ///
  /// お薬
  ///
  Future<void> writeMedicine(Medicine medicine) async {
    await FirebaseFirestore.instance.collection(_medicineRootName).doc(medicine.id.toString()).set(medicine.toMap());
  }

  Future<List<Medicine>> readMedicines() async {
    final snapshot = await FirebaseFirestore.instance.collection(_medicineRootName).get();
    return snapshot.docs.map((doc) => _fromMapByMedicine(doc)).toList();
  }

  Medicine _fromMapByMedicine(DocumentSnapshot doc) {
    return Medicine(
      id: int.parse(doc.id),
      name: doc.get('name') as String,
      overview: doc.get('overview') as String,
      imagePath: doc.get('imagePath') as String,
      type: Medicine.toType(doc.get('type') as int),
      memo: (doc.get('memo') as String) ?? '',
      order: doc.get('order') as int,
    );
  }

  ///
  /// 体調
  ///
  Future<void> writeCondition(Condition condition) async {
    await FirebaseFirestore.instance.collection(_conditionRootName).doc(condition.id.toString()).set(condition.toMap());
  }

  Future<List<Condition>> readConditions() async {
    final snapshot = await FirebaseFirestore.instance.collection(_conditionRootName).get();
    return snapshot.docs.map((doc) => _fromMapByCondition(doc)).toList();
  }

  Condition _fromMapByCondition(DocumentSnapshot doc) {
    return Condition(
      int.parse(doc.id),
      doc.get('name') as String,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyphic/model/condition.dart';

mixin AppFirestoreMixin {
  static final String _conditionRootName = 'conditions';

  Future<void> writeCondition(Condition condition) async {
    await FirebaseFirestore.instance.collection(_conditionRootName).doc(condition.id.toString()).set(condition.toMap());
  }

  Future<List<Condition>> readConditions() async {
    final snapshot = await FirebaseFirestore.instance.collection(_conditionRootName).get();
    return snapshot.docs.map((doc) => _fromMap(doc)).toList();
  }

  Condition _fromMap(DocumentSnapshot doc) {
    return Condition(
      int.parse(doc.id),
      doc.get('name') as String,
    );
  }
}

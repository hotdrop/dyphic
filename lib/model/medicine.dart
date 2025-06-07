class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.overview,
    required this.type,
    this.memo = '',
    required this.order,
  });

  factory Medicine.createEmpty(int id, int order) {
    return Medicine(
      id: id,
      name: '',
      overview: '',
      type: MedicineType.oral,
      memo: '',
      order: order,
    );
  }

  final int id;
  final String name;
  final String overview;
  final MedicineType type;
  final String memo;
  final int order;

  Medicine copyWith({required String imageUrl}) {
    return Medicine(
      id: id,
      name: name,
      overview: overview,
      type: type,
      order: order,
      memo: memo,
    );
  }

  String toTypeString() {
    switch (type) {
      case MedicineType.oral:
        return '内服薬';
      case MedicineType.notOral:
        return '頓服薬';
      case MedicineType.intravenous:
        return '点滴';
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

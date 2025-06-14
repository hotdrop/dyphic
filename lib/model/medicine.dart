class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.overview,
    required this.type,
    this.memo = '',
    required this.order,
    this.isDefault = true,
  });

  final int id;
  final String name;
  final String overview;
  final MedicineType type;
  final String memo;
  final int order;
  final bool isDefault;

  Medicine copyWith({
    String? name,
    String? overview,
    MedicineType? type,
    String? memo,
    int? order,
    bool? isDefault,
  }) {
    return Medicine(
      id: id,
      name: name ?? this.name,
      overview: overview ?? this.overview,
      type: type ?? this.type,
      order: order ?? this.order,
      memo: memo ?? this.memo,
      isDefault: isDefault ?? this.isDefault,
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

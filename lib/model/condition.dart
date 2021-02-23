class Condition {
  const Condition(this.id, this.name);

  factory Condition.empty() {
    return Condition(nonId, '');
  }

  static final int nonId = 0;

  final int id;
  final String name;

  bool get exist => id != nonId;

  Condition copyWith({String newName}) {
    return Condition(id, newName);
  }

  @override
  String toString() {
    return ' id: $id \n name: $name';
  }
}

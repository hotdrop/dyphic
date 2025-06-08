class Condition {
  const Condition(this.id, this.name);

  final int id;
  final String name;

  Condition copyWith({int? newId, String? newName}) {
    return Condition(
      newId ?? id,
      newName ?? name,
    );
  }

  @override
  String toString() {
    return ' id: $id \n name: $name';
  }
}

class Event {
  const Event({
    required this.id,
    required this.type,
    required this.name,
  });

  final int id;
  final EventType type;
  final String name;

  static EventType toType(int idx) {
    if (EventType.hospital.index == idx) {
      return EventType.hospital;
    } else if (EventType.injection.index == idx) {
      return EventType.injection;
    } else {
      return EventType.none;
    }
  }
}

enum EventType { none, hospital, injection }

import 'package:dyphic/model/graph_temperature.dart';
import 'package:dyphic/model/record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final graphViewModel = StateNotifierProvider.autoDispose<_GraphViewModel, AsyncValue<List<GraphTemperature>>>((ref) {
  return _GraphViewModel(ref.read);
});

class _GraphViewModel extends StateNotifier<AsyncValue<List<GraphTemperature>>> {
  _GraphViewModel(this._read) : super(const AsyncValue.loading()) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final records = _read(recordsProvider);
      if (records.isEmpty) {
        await _read(recordsProvider.notifier).onLoad();
      }

      return records
          .where((r) => _isRegisterTemperature(r)) //
          .map((r) => GraphTemperature.create(
                dateAt: r.date,
                morningTemperature: r.morningTemperature!,
                nightTemperature: r.nightTemperature!,
              ))
          .toList();
    });
  }

  bool _isRegisterTemperature(Record record) {
    return (record.morningTemperature ?? 0) > 0 || (record.nightTemperature ?? 0) > 0;
  }

  void changeType(GraphTemperatureRangeType type) {
    _read(graphTemperatureTypeSProvider.notifier).state = type;
  }
}

final graphTemperatureTypeSProvider = StateProvider<GraphTemperatureRangeType>((_) => GraphTemperatureRangeType.month);

enum GraphTemperatureRangeType { month, threeMonth, all }

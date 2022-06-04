import 'package:dyphic/model/graph_temperature.dart';
import 'package:dyphic/res/app_colors.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/ui/graph/graph_view_model.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends ConsumerWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.graphPageTitle),
      ),
      body: ref.watch(graphViewModel).when(
            data: (data) => _ViewOnSuccess(data),
            error: (err, _) => _ViewOnLoading(errorMsg: '$err'),
            loading: () => const _ViewOnLoading(),
          ),
    );
  }
}

class _ViewOnLoading extends StatelessWidget {
  const _ViewOnLoading({Key? key, this.errorMsg}) : super(key: key);

  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMsg != null) {
        await AppDialog.onlyOk(message: errorMsg!).show(context);
      }
    });
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ViewOnSuccess extends StatelessWidget {
  const _ViewOnSuccess(this.datas, {Key? key}) : super(key: key);

  final List<GraphTemperature> datas;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: _TemperatureGraph(
        morningDatas: datas.where((t) => t.morning > 0).toList(),
        nightDatas: datas.where((t) => t.night > 0).toList(),
      ),
    );
  }
}

class _TemperatureGraph extends ConsumerWidget {
  const _TemperatureGraph({Key? key, required this.morningDatas, required this.nightDatas}) : super(key: key);

  final List<GraphTemperature> morningDatas;
  final List<GraphTemperature> nightDatas;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _TemperatureRadio(type: GraphTemperatureRangeType.month, label: AppStrings.graphPageRadio1Month),
            _TemperatureRadio(type: GraphTemperatureRangeType.threeMonth, label: AppStrings.graphPageRadio3Month),
            _TemperatureRadio(type: GraphTemperatureRangeType.all, label: AppStrings.graphPageRadioAll),
          ],
        ),
        Expanded(
          child: Container(
            child: _createGraph(ref),
          ),
        ),
      ],
    );
  }

  Widget _createGraph(WidgetRef ref) {
    final type = ref.watch(graphTemperatureTypeSProvider);
    // 夜の体温データはほぼ未入力なので一旦無視している
    switch (type) {
      case GraphTemperatureRangeType.threeMonth:
        return _SfCartesianChart(_extractThreeMonth(morningDatas));
      case GraphTemperatureRangeType.all:
        return _SfCartesianChart(morningDatas);
      default:
        return _SfCartesianChart(_extractMonth(morningDatas));
    }
  }

  List<GraphTemperature> _extractMonth(List<GraphTemperature> datas) {
    final endAt = DateTime.now();
    final startAt = DateTime(endAt.year, endAt.month - 1, endAt.day, 0, 0, 0);
    return datas.where((d) => d.dateAt.isAfter(startAt)).toList();
  }

  List<GraphTemperature> _extractThreeMonth(List<GraphTemperature> datas) {
    final endAt = DateTime.now();
    final startAt = DateTime(endAt.year, endAt.month - 3, endAt.day, 0, 0, 0);
    return datas.where((d) => d.dateAt.isAfter(startAt)).toList();
  }
}

class _TemperatureRadio extends ConsumerWidget {
  const _TemperatureRadio({Key? key, required this.type, required this.label}) : super(key: key);

  final GraphTemperatureRangeType type;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Radio<GraphTemperatureRangeType>(
          value: type,
          groupValue: ref.watch(graphTemperatureTypeSProvider),
          onChanged: (GraphTemperatureRangeType? newVal) {
            if (newVal != null) {
              ref.read(graphViewModel.notifier).changeType(newVal);
            }
          },
        ),
        Text(label),
      ],
    );
  }
}

///
/// グラフウィジェット
///
class _SfCartesianChart extends StatelessWidget {
  const _SfCartesianChart(this.morningDatas);

  final List<GraphTemperature> morningDatas;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 7,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}${AppStrings.graphPageGraphYAxisUnit}',
        interval: 0.1,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
      ),
      palette: const <Color>[AppColors.morningTemperature],
      series: _convertLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<_ChartData, String>> _convertLineSeries() {
    final moringChartDatas = morningDatas.map((d) => _ChartData('${d.month}月${d.day}日', d.morning)).toList();

    return <LineSeries<_ChartData, String>>[
      LineSeries<_ChartData, String>(
        animationDuration: 2500,
        dataSource: moringChartDatas,
        xValueMapper: (_ChartData temp, _) => temp.x,
        yValueMapper: (_ChartData temp, _) => temp.y,
        name: AppStrings.graphPageGraphMorningLabel,
        markerSettings: const MarkerSettings(isVisible: true),
      ),
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

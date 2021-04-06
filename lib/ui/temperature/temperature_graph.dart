import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/graph_temperature_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TemperatureGraph extends StatelessWidget {
  const TemperatureGraph(this.title, this._datas);

  final String title;
  final List<GraphTemperatureData> _datas;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: title),
      primaryXAxis: CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 7,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}度',
        interval: 0.1,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      series: _convertLineSeries(_datas),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<_ChartData, String>> _convertLineSeries(List<GraphTemperatureData> datas) {
    final charDatas = datas.map((d) {
      final xVal = '${d.month}月${d.day}日';
      return _ChartData(xVal, d.morning);
    }).toList();

    return <LineSeries<_ChartData, String>>[
      LineSeries<_ChartData, String>(
        animationDuration: 2500,
        dataSource: charDatas,
        xValueMapper: (_ChartData temp, _) => temp.x,
        yValueMapper: (_ChartData temp, _) => temp.y,
        name: AppStrings.temperaturePageGraphMorningLabel,
        markerSettings: MarkerSettings(isVisible: true),
      ),
    ];
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

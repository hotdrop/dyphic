import 'package:dyphic/common/app_colors.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/graph_temperature_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TemperatureGraph extends StatefulWidget {
  const TemperatureGraph({required this.morningDatas, required this.nightDatas});

  final List<GraphTemperatureData> morningDatas;
  final List<GraphTemperatureData> nightDatas;

  @override
  State<StatefulWidget> createState() => _TemperatureGraphState();
}

class _TemperatureGraphState extends State<TemperatureGraph> {
  _RadioValue _radioValue = _RadioValue.both;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _radio(_RadioValue.both, AppStrings.temperatureRadioBoth),
              _radio(_RadioValue.onlyMorning, AppStrings.temperatureRadioOnlyMoring),
              _radio(_RadioValue.onlyNight, AppStrings.temperatureRadioOnlyNight),
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: _createGraph(),
          ),
        ),
      ],
    );
  }

  Widget _radio(_RadioValue radioVal, String label) {
    return Row(
      children: [
        Radio(value: radioVal, groupValue: _radioValue, onChanged: _handleRadioValueChanged),
        Text(label),
      ],
    );
  }

  void _handleRadioValueChanged(_RadioValue? value) {
    if (value != null) {
      setState(() {
        _radioValue = value;
      });
    }
  }

  Widget _createGraph() {
    switch (_radioValue) {
      case _RadioValue.onlyMorning:
        return _createSfCartesianChart(moringDatas: widget.morningDatas);
      case _RadioValue.onlyNight:
        return _createSfCartesianChart(nightDatas: widget.nightDatas);
      default:
        return _createSfCartesianChart(moringDatas: widget.morningDatas, nightDatas: widget.nightDatas);
    }
  }

  SfCartesianChart _createSfCartesianChart({
    List<GraphTemperatureData>? moringDatas,
    List<GraphTemperatureData>? nightDatas,
  }) {
    final palette = <Color>[
      if (moringDatas != null) AppColors.morningTemperature,
      if (nightDatas != null) AppColors.nightTemperature
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 7,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}${AppStrings.temperaturePageGraphYAxisUnit}',
        interval: 0.1,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(color: Colors.transparent),
      ),
      palette: palette,
      series: _convertLineSeries(moringDatas, nightDatas),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<_ChartData, String>> _convertLineSeries(
    List<GraphTemperatureData>? moringDatas,
    List<GraphTemperatureData>? nightDatas,
  ) {
    final moringChartDatas = moringDatas?.map((d) => _ChartData('${d.month}月${d.day}日', d.morning)).toList();
    final nightChartDatas = nightDatas?.map((d) => _ChartData('${d.month}月${d.day}日', d.night)).toList();

    return <LineSeries<_ChartData, String>>[
      if (moringChartDatas != null)
        LineSeries<_ChartData, String>(
          animationDuration: 2500,
          dataSource: moringChartDatas,
          xValueMapper: (_ChartData temp, _) => temp.x,
          yValueMapper: (_ChartData temp, _) => temp.y,
          name: AppStrings.temperaturePageGraphMorningLabel,
          markerSettings: MarkerSettings(isVisible: true),
        ),
      if (nightChartDatas != null)
        LineSeries<_ChartData, String>(
          animationDuration: 2500,
          dataSource: nightChartDatas,
          xValueMapper: (_ChartData temp, _) => temp.x,
          yValueMapper: (_ChartData temp, _) => temp.y,
          name: AppStrings.temperaturePageGraphNightLabel,
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

enum _RadioValue { both, onlyMorning, onlyNight }

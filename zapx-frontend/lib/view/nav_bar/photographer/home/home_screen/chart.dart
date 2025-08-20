import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zapxx/configs/color/color.dart';

class AppointmentBarChart extends StatelessWidget {
  final List<AppointmentData> chartData = [
    AppointmentData('Sun', 3),
    AppointmentData('Mon', 2),
    AppointmentData('Tue', 3),
    AppointmentData('Wed', 4),
    AppointmentData('Thu', 1),
    AppointmentData('Fri', 5),
    AppointmentData('Sat', 2),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(isVisible: false),
      // title: ChartTitle(text: 'Appointments per Day'),
      legend: const Legend(isVisible: false),
      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),
      series: <CartesianSeries>[
        ColumnSeries<AppointmentData, String>(
          dataSource: chartData,
          xValueMapper: (AppointmentData data, _) => data.day,
          yValueMapper: (AppointmentData data, _) => data.appointmentCount,
          name: 'Appointments',
          color: AppColors.backgroundColor,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class AppointmentData {
  final String day;
  final int appointmentCount;

  AppointmentData(this.day, this.appointmentCount);
}

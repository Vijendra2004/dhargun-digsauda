import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
class ChartSeries {
  String category="";
  double value=0;
  charts.Color barColor;

  ChartSeries(
      {
        required this.category,
        required this.value,
        required this.barColor
      }
      );
}
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:inmobiliariapp/utils/theme.dart';

class GraficoBarras extends StatefulWidget {
  const GraficoBarras({Key? key}) : super(key: key);

  @override
  State<GraficoBarras> createState() => _GraficoBarrasState();
}

class _GraficoBarrasState extends State<GraficoBarras> {
  final Color barColor = colorAzul;
  final double width = 10;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final barGroup1 = makeGroupData(0, 5);
    final barGroup2 = makeGroupData(1, 16);
    final barGroup3 = makeGroupData(2, 18);
    final barGroup4 = makeGroupData(3, 20);
    final barGroup5 = makeGroupData(4, 17);
    final barGroup6 = makeGroupData(5, 19);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
    ];
    
    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData(),
        barGroups: showingBarGroups,
        titlesData: titlesData(),
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        maxY: 30,
      ),
    );
  }

  FlTitlesData titlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: bottomTitles,
          reservedSize: 42,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          getTitlesWidget: leftTitles,
          reservedSize: 28,
        ),
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('L', style: style);
        break;
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('X', style: style);
        break;
      case 3:
        text = const Text('J', style: style);
        break;
      case 4:
        text = const Text('V', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(padding: const EdgeInsets.only(top: 10), child: text);
  }

  BarTouchData barTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Theme.of(context).backgroundColor,
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    String text;
    text = '$value';
    return Text(text, style: style);
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [colorAzul, masClaro]
                : [masOscuro, colorAzul],
            tileMode: TileMode.mirror,
          ),
          width: width,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }
}

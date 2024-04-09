import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class PokeStats extends StatefulWidget  {
  // ignore: prefer_typing_uninitialized_variables
  final stats;

  PokeStats({
    super.key,
    required this.stats,
  });
  final Color dark = Color.fromARGB(255, 3, 67, 119);
  final Color normal = Colors.blueAccent;
  final Color light = Colors.blueGrey;
  @override
  State<StatefulWidget> createState() => PokeBarChart();
}


class PokeBarChart extends State<PokeStats> {
  
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'HP';
        break;
      case 1:
        text = 'Atk';
        break;
      case 2:
        text = 'Def';
        break;
      case 3:
        text = 'sAtk';
        break;
      case 4:
        text = 'sDef';
        break;
      default:
        text = 'Spd';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 40.0 * constraints.maxWidth / 400;
            final barsWidth = 10.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Colors.grey,
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      //HP
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.stats['hp'],
            rodStackItems: [
              BarChartRodStackItem(0, 50, widget.dark),
              BarChartRodStackItem(50, 150, widget.normal),
              BarChartRodStackItem(150, 300, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),          
          
        ],
      ),

      //Atk
      BarChartGroupData(
        x: 1,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.stats['attack'],
            rodStackItems: [
              BarChartRodStackItem(0, 50, widget.dark),
              BarChartRodStackItem(50, 100, widget.normal),
              BarChartRodStackItem(100, 190, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          
        ],
      ),

      //Def
      BarChartGroupData(
        x: 2,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.stats['defense'],
            rodStackItems: [
              BarChartRodStackItem(0, 50, widget.dark),
              BarChartRodStackItem(50, 150, widget.normal),
              BarChartRodStackItem(150, 230, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          
        ],
      ),

      //sAtk
      BarChartGroupData(
        x: 3,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.stats['sAttack'],
            rodStackItems: [
              BarChartRodStackItem(0, 50, widget.dark),
              BarChartRodStackItem(50, 100, widget.normal),
              BarChartRodStackItem(100, 170, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          
        ],
      ),

      //sDef
      BarChartGroupData(
        x: 4,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.stats['sDefense'],
            rodStackItems: [
              BarChartRodStackItem(0, 50, widget.dark),
              BarChartRodStackItem(50, 100, widget.normal),
              BarChartRodStackItem(100, 170, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          
        ],
      ),

      //Spd
      BarChartGroupData(
        x: 5,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: widget.stats['speed'],
            rodStackItems: [
              BarChartRodStackItem(0, 50, widget.dark),
              BarChartRodStackItem(50, 150, widget.normal),
              BarChartRodStackItem(150, 200, widget.light),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          
        ],
      ),
      
    ];
  }
}
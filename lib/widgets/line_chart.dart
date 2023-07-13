import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineChartWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double prevValue = 9223372036854775807.toDouble();
    List intervalValues=[9223372036854775807, 0];
    List<FlSpot> spots = data.entries.map((entry) {
      if(entry.value < intervalValues[0]) {
          intervalValues[0] = entry.value;
      }
      if(entry.value > intervalValues[1]) {
        intervalValues[1] = entry.value;
      }
      DateTime time = DateTime.parse(entry.key);
      double value = entry.value;
      return FlSpot(time.microsecondsSinceEpoch.toDouble(), value);
    }).toList();
    var color = Colors.green;
    if( double.parse(spots[0].props[1]!.toString()) - double.parse(spots[spots.length-1].props[1]!.toString()) > 0){
      color = Colors.red;
    }
    return Container(
      // Set the desired height
      padding: EdgeInsets.all(10.h),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                getTooltipItems: (touchedSpots){
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    TextStyle textStyle = TextStyle(
                      color: Colors.white, // Set the color of the tooltip text
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    );
                    return LineTooltipItem(
                      '${touchedSpot.y}',
                      textStyle,
                    );
                  }).toList();
                },
              ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 2,
              isStrokeCapRound: true,

              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: color,
                gradient: LinearGradient(
                  colors: [
                    color == Colors.green ? Colors.green.shade900 : Colors.red.shade900.withOpacity(0.8),
                    Colors.black,
                  ],

                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
                )
              )
            ),
          ],
          minX: spots.first.x+10,
          maxX: spots.last.x,
          minY: spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b),
          maxY: spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
            )),
            leftTitles: AxisTitles(sideTitles:
              SideTitles(showTitles: true,
                reservedSize: 35.w,
                interval: (data.length/6).round().toDouble(),
                getTitlesWidget: (value, meta) {
                if((prevValue - value).abs() >  ((intervalValues[1] - intervalValues[0])/6).round()){
                  prevValue = value;
                  String printVal;
                  if (value.round() > 99999 ){
                    printVal = '${(value/1000).round()}k';
                  }
                  else if (value.round() > 9999 ){
                    printVal = '${(value/1000).toStringAsFixed(1)}k';
                  }
                  else{
                    printVal = value.round().toString();
                  }
                  return Center(child: Text(printVal,overflow: TextOverflow.visible, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15.sp),));
                }
                return const SizedBox(height: 0,width: 0,);
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false),),
          ),
          gridData: FlGridData(
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white24,
                strokeWidth: 1,
              );
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.white24,
                strokeWidth: 1,
              );
            },
          ),
        ),
      ),
    );
  }
}

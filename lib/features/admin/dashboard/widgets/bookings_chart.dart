import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/mock/mock_analytics.dart';

class BookingsChart extends StatelessWidget {
  const BookingsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockAnalytics.weeklyBookings;
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 10, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.divider, strokeWidth: 1)),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text('${v.toInt()}', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) {
              final idx = v.toInt();
              if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
              return Text(data[idx]['day'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, fontSize: 10));
            })),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(data.length, (i) => BarChartGroupData(
            x: i,
            barRods: [BarChartRodData(toY: (data[i]['count'] as int).toDouble(), color: AppColors.primary, width: 24, borderRadius: const BorderRadius.vertical(top: Radius.circular(6)))],
          )),
          maxY: 40,
        ),
      ),
    );
  }
}

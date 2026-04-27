import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/stats_provider.dart';

class RevenueChart extends ConsumerWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(orderStatsProvider);

    return statsAsync.when(
      loading: () => Container(
        height: 220,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 2))
          ],
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Center(
          child: Text('Could not load chart',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
        ),
      ),
      data: (stats) {
        final data = (stats['monthlyOrders'] as List?)
                ?.cast<Map<String, dynamic>>() ??
            [];
        final maxY = data.isEmpty
            ? 10.0
            : data
                .map((e) => (e['count'] as int? ?? 0).toDouble())
                .reduce((a, b) => a > b ? a : b)
                .clamp(1.0, double.infinity) *
            1.2;

        return Container(
          height: 220,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 10,
                  offset: Offset(0, 2))
            ],
          ),
          child: data.isEmpty
              ? Center(
                  child: Text('No data yet',
                      style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary)))
              : LineChart(LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                        color: AppColors.divider, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            data[idx]['month']?.toString() ?? '',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        data.length,
                        (i) => FlSpot(
                          i.toDouble(),
                          (data[i]['count'] as int? ?? 0).toDouble(),
                        ),
                      ),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: maxY,
                )),
        );
      },
    );
  }
}

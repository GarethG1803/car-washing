import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:clean_ride/core/theme/app_colors.dart';
import 'package:clean_ride/core/theme/app_typography.dart';
import 'package:clean_ride/core/theme/app_spacing.dart';
import 'package:clean_ride/data/providers/stats_provider.dart';
import 'package:gap/gap.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(orderStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const Gap(12),
              Text('Could not load analytics',
                  style: AppTypography.titleMedium),
              const Gap(16),
              TextButton(
                onPressed: () => ref.invalidate(orderStatsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (stats) {
          final weeklyBookings = (stats['weeklyBookings'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          final monthlyOrders = (stats['monthlyOrders'] as List?)
                  ?.cast<Map<String, dynamic>>() ??
              [];
          final total = stats['totalOrders'] as int? ?? 0;
          final completed = stats['completedOrders'] as int? ?? 0;
          final cancelled = stats['cancelledOrders'] as int? ?? 0;
          final pending = stats['pendingOrders'] as int? ?? 0;
          final active = stats['activeOrders'] as int? ?? 0;

          final maxWeekly = weeklyBookings.isEmpty
              ? 1.0
              : weeklyBookings
                  .map((e) => (e['count'] as int? ?? 0).toDouble())
                  .reduce((a, b) => a > b ? a : b)
                  .clamp(1.0, double.infinity);

          final maxMonthly = monthlyOrders.isEmpty
              ? 1.0
              : monthlyOrders
                  .map((e) => (e['count'] as int? ?? 0).toDouble())
                  .reduce((a, b) => a > b ? a : b)
                  .clamp(1.0, double.infinity);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  _statCard('Total', '$total', AppColors.primary),
                  const Gap(12),
                  _statCard('Done', '$completed', AppColors.success),
                  const Gap(12),
                  _statCard('Active', '$active', AppColors.warning),
                  const Gap(12),
                  _statCard('Cancelled', '$cancelled', AppColors.error),
                ]),
                const Gap(24),
                Text('Weekly Bookings',
                    style: AppTypography.titleMedium),
                const Gap(12),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: weeklyBookings.isEmpty
                      ? Center(
                          child: Text('No data',
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary)))
                      : BarChart(BarChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (v) => FlLine(
                                color: AppColors.divider,
                                strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (v, m) => Text(
                                  '${v.toInt()}',
                                  style: AppTypography.labelSmall
                                      .copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, m) {
                                  final idx = v.toInt();
                                  if (idx < 0 ||
                                      idx >= weeklyBookings.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    weeklyBookings[idx]['day']
                                            ?.toString() ??
                                        '',
                                    style: AppTypography.labelSmall
                                        .copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                            weeklyBookings.length,
                            (i) => BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: (weeklyBookings[i]['count']
                                              as int? ??
                                          0)
                                      .toDouble(),
                                  color: AppColors.primary,
                                  width: 24,
                                  borderRadius:
                                      const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          maxY: maxWeekly * 1.2,
                        )),
                ),
                const Gap(24),
                Text('Monthly Orders', style: AppTypography.titleMedium),
                const Gap(12),
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: monthlyOrders.isEmpty
                      ? Center(
                          child: Text('No data',
                              style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary)))
                      : LineChart(LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (v) => FlLine(
                                color: AppColors.divider,
                                strokeWidth: 1),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (v, m) => Text(
                                  '${v.toInt()}',
                                  style: AppTypography.labelSmall
                                      .copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, m) {
                                  final idx = v.toInt();
                                  if (idx < 0 ||
                                      idx >= monthlyOrders.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    monthlyOrders[idx]['month']
                                            ?.toString() ??
                                        '',
                                    style: AppTypography.labelSmall
                                        .copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles:
                                    SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                monthlyOrders.length,
                                (i) => FlSpot(
                                  i.toDouble(),
                                  (monthlyOrders[i]['count'] as int? ??
                                          0)
                                      .toDouble(),
                                ),
                              ),
                              isCurved: true,
                              color: AppColors.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: AppColors.primary
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                          ],
                          minY: 0,
                          maxY: maxMonthly * 1.2,
                        )),
                ),
                const Gap(24),
                Text('Order Breakdown',
                    style: AppTypography.titleMedium),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 10,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: Column(children: [
                    if (total > 0)
                      _funnelRow('Total Orders', '$total', 1.0),
                    if (total > 0) ...[
                      _funnelRow('Completed', '$completed',
                          completed / total),
                      _funnelRow(
                          'Active', '$active', active / total),
                      _funnelRow(
                          'Pending', '$pending', pending / total),
                      _funnelRow('Cancelled', '$cancelled',
                          cancelled / total),
                    ] else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16),
                        child: Text(
                          'No orders yet',
                          style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary),
                        ),
                      ),
                  ]),
                ),
                const Gap(32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(children: [
          Text(value,
              style: AppTypography.titleLarge.copyWith(
                  color: color, fontWeight: FontWeight.bold)),
          const Gap(2),
          Text(label,
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _funnelRow(String label, String value, double pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.bodyMedium),
              Text(value,
                  style: AppTypography.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const Gap(6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.isNaN ? 0 : pct,
              minHeight: 8,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation(
                AppColors.primary.withValues(
                    alpha: (0.3 + pct * 0.7).clamp(0.0, 1.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
